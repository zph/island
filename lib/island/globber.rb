module Island
  module Globber
    def self.default(repo, bin)
      globs = [
                "#{repo}/lib/**/*.rb",
                "#{repo}/bin/#{bin}",
              ]
    end
    def self.call(gem_name, *args)
      files = args.flat_map do |g|
        Dir.glob(g)
      end

      files.insert(0, files.grep(%r(lib/#{ gem_name }[\./])).reverse)
    end
  end
end
