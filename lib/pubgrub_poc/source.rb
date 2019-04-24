module PubGrubPoc
  class Source < PubGrub::BasicPackageSource
    include PubGrub::RubyGems

    def initialize(manifest, repository, lockfile = nil)
      super()

      @manifest = manifest
      @repository = repository
      @lockfile = lockfile
      @packages = {}
    end

    def all_versions_for(package)
      PubGrubPoc.logger.info('[source]') do
        "Getting all versions of `#{package}`"
      end

      versions = repository.versions(package)
      versions = lockfile.sort(package, versions) if lockfile
      PubGrubPoc.logger.debug('[source]') do
        "Found [#{versions.map(&:to_s).join(', ')}]"
      end
      versions
    end

    def root_dependencies
      PubGrubPoc.logger.info('[source]') do
        "Getting root dependencies from manifest"
      end
      manifest.dependencies
    end

    def dependencies_for(package, version)
      PubGrubPoc.logger.info('[source]') do
        "Getting dependencies for `#{package}` (#{version})"
      end

      repository.dependencies(package, version).tap do |dependencies|
        PubGrubPoc.logger.debug('[source]') do
          "Found #{dependencies.inspect}"
        end
      end
    end

    def parse_dependency(package, dependency)
      PubGrubPoc.logger.info('[source]') do
        "Parsing dependency #{dependency} for `#{package}`"
      end

      parse_range(dependency)
    end

    private

    attr_reader :manifest, :repository, :lockfile
  end
end
