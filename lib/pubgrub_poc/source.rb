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
      log(:info, "Getting all versions of `#{package}`")

      versions = repository.versions(package)
      versions = lockfile.sort(package, versions) if lockfile
      log(:debug, "Found [#{versions.map(&:to_s).join(', ')}]")
      versions
    end

    def root_dependencies
      log(:info, "Getting root dependencies from manifest")
      manifest.dependencies
    end

    def dependencies_for(package, version)
      log(:info, "Getting dependencies for `#{package}` (#{version})")

      repository.dependencies(package, version).tap do |dependencies|
        log(:debug, "Found #{dependencies.inspect}")
      end
    end

    def parse_dependency(package, dependency)
      log(:info, "Parsing dependency #{dependency} for `#{package}`")

      parse_range(dependency)
    end

    def package_priority(package, versions)
      return 0 unless lockfile

      log(
        :info,
        "Getting priority for `#{package}` [#{versions.map(&:to_s).join(', ')}]"
      )
      lockfile.package_priority(package, versions).tap do |priority|
        log(:debug, "Found #{priority}")
      end
    end

    private

    attr_reader :manifest, :repository, :lockfile

    def log(severity, message)
      PubGrubPoc.logger.public_send(severity, '[source]') { message }
    end
  end
end
