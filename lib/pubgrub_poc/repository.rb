module PubGrubPoc
  class Repository
    def initialize(path)
      @path = path
    end

    def versions(package)
      data.fetch(package).map do |package|
        Gem::Version.new(package['version'])
      end.sort.reverse # Reverse-sorting in order to prioritize recent versions
    end

    def dependencies(package, version)
      item = data.fetch(package).detect { |p| p['version'] == version.to_s }

      item.fetch('dependencies').each_with_object({}) do |dependency, memo|
        memo[dependency['name']] = dependency['version']
      end
    end

    private

    attr_reader :path

    def data
      @data = YAML.load_file(path)
    end
  end
end
