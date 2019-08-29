module PubGrubPoc
  class Pinfile
    def initialize(path)
      @path = path
    end

    def pinned_version(package)
      Gem::Version.new(data[package])
    end

    def pinned?(package)
      data.key?(package)
    end

    private

    attr_reader :path

    def data
      @data ||= YAML.load_file(path)
    end
  end
end
