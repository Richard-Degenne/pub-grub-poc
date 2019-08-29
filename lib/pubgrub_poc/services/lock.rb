module PubGrubPoc
  module Services
    class Lock
      def initialize(
        manifest_path = PubGrubPoc.manifest_path,
        repository_path = PubGrubPoc.repository_path,
        lockfile_path = PubGrubPoc.lockfile_path,
        pinfile_path = PubGrubPoc.pinfile_path,
        output_lockfile_path = lockfile_path,
        output_pinfile_path = pinfile_path,
        **options
      )
        @manifest_path = manifest_path
        @repository_path = repository_path
        @lockfile_path = lockfile_path
        @pinfile_path = pinfile_path
        @output_lockfile_path = output_lockfile_path || PubGrubPoc.lockfile_path
        @output_pinfile_path = output_pinfile_path || PubGrubPoc.pinfile_path
        @options = options
      end

      def run
        while !solver.solved?
          log(:info, 'Starting new work step')
          solver.work
        end

        log(:info, "Solution found: #{solver.solution.decisions.inspect}")
        log(:info, "Writing solution to `#{output_lockfile_path}`")
        File.write(
          output_lockfile_path, Serializer.new(solver.solution).dump
        )
      rescue PubGrub::SolveFailure => e
        log(:fatal, "Solver failed:\n#{e.message}")
      end


      private

      attr_reader :manifest_path, :repository_path, :lockfile_path,
        :output_lockfile_path, :pinfile_path, :output_pinfile_path, :options

      def manifest
        @manifest ||= Manifest.new(manifest_path)
      end

      def repository
        @repository ||= Repository.new(repository_path)
      end

      def lockfile
        return unless File.exist?(lockfile_path)

        @lockfile ||= Lockfile.new(
          lockfile_path, overrides: options[:overrides], mode: options[:mode]
        )
      end

      def pinfile
        return unless File.exist?(pinfile_path)

        @pinfile ||= Pinfile.new(pinfile_path)
      end

      def source
        @source ||= Source.new(manifest, repository, lockfile, pinfile)
      end

      def solver
        @solver ||= Solver.new(source: source)
      end

      def log(severity, message)
        PubGrubPoc.logger.send(severity, '[lock]') { message }
      end
    end
  end
end
