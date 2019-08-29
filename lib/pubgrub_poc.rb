require 'pub_grub'
require 'pub_grub/rubygems'
require 'yaml'

module PubGrubPoc
  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def data_file(*path)
      File.join(__dir__, '../data', *path)
    end

    def manifest_path
      data_file('manifest.yaml')
    end

    def lockfile_path
      data_file('lockfile.yaml')
    end

    def pinfile_path
      data_file('pinfile.yaml')
    end

    def repository_path
      data_file('repository.yaml')
    end
  end
end

require_relative 'pubgrub_poc/lockfile'
require_relative 'pubgrub_poc/manifest'
require_relative 'pubgrub_poc/pinfile'
require_relative 'pubgrub_poc/repository'
require_relative 'pubgrub_poc/serializer'
require_relative 'pubgrub_poc/services'
require_relative 'pubgrub_poc/solver'
require_relative 'pubgrub_poc/source'
