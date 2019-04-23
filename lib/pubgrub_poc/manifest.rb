module PubGrubPoc
  class Manifest
    def initialize(path)
      @path = path
    end

    def version
      data.fetch('version')
    end

    def dependencies
      data.fetch('dependencies').each_with_object({}) do |d, memo|
        memo[d['name']] = d['version'] || '>= 0'
      end
    end

    private

    attr_reader :path

    def data
      @data ||= YAML.load_file(path)
    end
  end
end
