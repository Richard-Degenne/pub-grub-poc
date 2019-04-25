module PubGrubPoc
  class Solver < PubGrub::VersionSolver
    private

    ##
    # Gets the next package to solve for.
    #
    # Overriding the PubGrub implementation here so that `source` can influence
    # the result.
    #
    # @see Source#package_priority
    def next_package_to_try
      solution.unsatisfied.min_by do |term|
        package = term.package
        versions = source.versions_for(package, term.constraint.range)

        [
          source.package_priority(package, versions), @package_depth[package],
          versions.count
        ]
      end.package
    end
  end
end
