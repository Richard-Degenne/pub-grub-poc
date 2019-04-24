module PubGrubPoc
  class Lockfile
    def initialize(path, mode: :hold)
      @path = path
      @mode = mode
    end

    ##
    # Sorts a given set of versions according to lockfile preferences.
    def sort(package, versions)
      # Return as is if lockfile does not contain `package`.
      return versions unless (locked_version = data[package])

      locked_version = Gem::Version.new(locked_version)
      versions.partition do |version|
        satisfy?(version, locked_version)
      end.inject(:+)
    end

    private

    attr_reader :path, :mode

    def satisfy?(version, locked_version)
      operator = case mode
      when :hold
        version == locked_version
      when :major
        version >= locked_version
      end
    end

    def data
      @data ||= YAML.load_file(path)
    end
  end
end
