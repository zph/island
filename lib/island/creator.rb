module Island

  class Creator
    attr_accessor :files, :content
    def self.call(files, opts={})
      files = Set.new(files)
      rejects = opts.fetch(:rejects)    { Plugins::REJECTIONS }
      mods = opts.fetch(:modifications) { Plugins::MODIFICATIONS }
      creator = new(files)
      files_hash = creator.read_content
      files_hash = creator.alter_each_file(files_hash)
      ## process each file
      content = creator.blend_files(files_hash)
      r = creator.requires(content)

      creator.ensure_dependencies(r, files)

      content = creator.reject_line(content, rejects)
      content = creator.modify_lines(content, mods)
      creator.join_lines(content)
    end

    def alter_each_file(hash)
      # Act on the array of lines of each file
      # ie prepend ==Start of filename / ==End of filename
      # h.map do |k,v|
      # end

      hash
    end

    def blend_files(hash)
      @content = hash.values.flatten
    end

    def ensure_dependencies(libs, files)
      to_include    = libs.select { |k,v| v == false }.keys
      to_include.flat_map do |line|
        found = files.grep(/#{line}/)
        if found.empty?
          warn "Please include #{line} in files list"
          exit(1)
        end
        found
      end
    end

    def requires(content)
      reqs = content.select { |i| i[/^\s?require/]}
                 .map { |o| o[/['"](.*)['"]/]; $1 }[0..6]
      hash = reqs.map { |o| stdlib?(o) }.flatten
      Hash[*hash]
    end

    def stdlib?(lib)
      result = false
      s = Thread.new do
            begin
              require lib
              result = true
            rescue LoadError
              result = false
            end
          end
      s.join
      [lib, result]
    end

    def initialize(files)
      @files = files
    end

    def read_content(f = files)
      Hash[*f.flat_map { |z| [z, File.open(z).readlines.map(&:chomp)] }]
    end

    def reject_line(c, plugins = Plugins::REJECTIONS)
      # plugins must eval to true for it to be removed
      plugins.each_with_object(c) do |b, obj|
        obj.reject!{ |l| b.call(l) }
      end
    end

    def modify_lines(c, plugins = Plugins::MODIFICATIONS)
      plugins.each_with_object(c) do |b, obj|
        b.call(obj)
      end
    end

    def join_lines(c = content)
      c.join("\n") + "\n"
    end
  end
end
