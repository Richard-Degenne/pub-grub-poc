module PubGrubPoc
  class Lockfile
    def initialize(path, overrides: nil, mode: nil)
      @path = path
      @overrides = overrides || []
      @mode = mode || :hold
    end

    ##
    # Sorts a given set of versions according to lockfile preferences.
    def sort(package, versions)
      # Return as is if `package` is in the overrides.
      return versions if overrides.include?(package)
      # Return as is if lockfile does not contain `package`.
      return versions unless data.key?(package)

      preferences(package, versions).inject(:+)
    end

    ##
    # Priority of solving for the given package.
    #
    # Lower values means more precedence. The strategy here is the following:
    #
    # - Solve for overrides first. That way, packages currently updating
    #   will not be blocked by their dependencies.
    # - Solve for locked packages next, provided the locked version is still
    #   compliant with the constraints. That way, we ensure minimal differences
    #   between the current lockfile and the solution.
    # - If the source has no information, let the solver decide.
    #
    # @see Solver#next_package_to_try
    def package_priority(package, versions)
      return -2 if overrides.include?(package)
      return 0 unless data.key?(package)

      preferences(package, versions).all?(&:any?) ? -1 : 0
    end

    private

    attr_reader :path, :overrides, :mode

    def preferences(package, versions)
      versions.partition { |version| satisfy?(package, version) }
    end

    def satisfy?(package, version)
      locked_version = Gem::Version.new(data[package])
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
