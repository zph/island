module Island

  class Creator
    attr_accessor :files, :content
    def self.call(files, opts={})
      files = Set.new(files)
      rejects = opts.fetch(:rejects)    { Plugins::REJECTIONS }
      mods = opts.fetch(:modifications) { Plugins::MODIFICATIONS }
      i = new(files)
      h = i.read_content
      h = i.alter_each_file(h)
      ## process each file
      c = i.blend_files(h)
      r = i.requires(c)

      i.ensure_dependencies(r, files)

      c = i.reject_line(c, rejects)
      c = i.modify_lines(c, mods)
      i.join_lines(c)
    end

    def alter_each_file(h)
      # Act on the array of lines of each file
      # ie prepend ==Start of filename / ==End of filename
      # h.map do |k,v|

      # end
      h
    end

    def blend_files(h)
      @content = h.values.flatten
    end

    def self.requires(files, opts={})
      # TODO: temporary
      i       = new(files)
      c       = i.read_content
      r       = i.requires(c)
      i.ensure_dependencies(r, files)
    end

    def ensure_dependencies(libs, files)
      to_include    = libs.select { |k,v| v == false }.keys
      to_include.flat_map do |l|
        found = files.grep(/#{l}/)
        if found.empty?
          warn "Please include #{l} in files list"
          exit(1)
        end
        found
      end
    end

    def requires(c)
      r = c.select { |i| i[/^\s?require/]}
           .map { |o| o[/['"](.*)['"]/]; $1 }[0..6]
      h = r.map { |o| stdlib?(o) }.flatten
      Hash[*h]
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
      c = plugins.each_with_object(c) do |b, obj|
        obj.reject!{ |l| b.call(l) }
      end
    end

    def modify_lines(c, plugins = Plugins::MODIFICATIONS)
      c = plugins.each_with_object(c) do |b, obj|
        b.call(obj)
      end
    end

    def join_lines(c = content)
      c.join("\n") + "\n"
    end
  end
end
