require 'pub_grub'
require 'pub_grub/rubygems'
require 'yaml'

module PubGrubPoc
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end

require_relative 'pubgrub_poc/lockfile'
require_relative 'pubgrub_poc/manifest'
require_relative 'pubgrub_poc/repository'
require_relative 'pubgrub_poc/serializer'
require_relative 'pubgrub_poc/source'
