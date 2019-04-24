module PubGrubPoc
  class Serializer
    def initialize(solution)
      @solution = solution
    end

    def dump
      YAML.dump(data)
    end

    private

    attr_reader :solution

    def data
      solution.decisions.each_with_object({}) do |(package, version), memo|
        next if package == PubGrub::Package.root

        memo[package.to_s] = version.to_s
      end
    end
  end
end
