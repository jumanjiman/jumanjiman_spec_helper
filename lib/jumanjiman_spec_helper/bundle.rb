# vim: set ts=2 sw=2 ai et ruler:
module JumanjimanSpecHelper
  module Bundle
    require 'rubygems' # ugh, support older distros
    require 'bundler'
    require 'yaml'

    # lock dependencies and setup load paths
    # http://myronmars.to/n/dev-blog/2012/12/5-reasons-to-avoid-bundler-require
    # http://anti-pattern.com/bundler-setup-vs-bundler-require
    def self.setup(envs = [:default], load_early = false)
      if load_early
        # load all gems at startup
        Bundler.require(envs)
      else
        # do not load until required
        Bundler.setup(envs)
      end
    rescue Bundler::GemfileNotFound,
      Bundler::GemNotFound,
      Bundler::VersionConflict => e
      # some of us are not ruby experts; we need a reminder
      print_bundle_error e
      exit
    rescue Exception => e
      puts e.class
      puts e.message
      puts e.backtrace
      exit
    end

    def self.bundle_config
      File.join('.bundle', 'config')
    end

    def self.desired_bundle
      File.join(ENV['HOME'], '.bundle')
    end

    def self.actual_bundle
      path = YAML.load_file(bundle_config)['BUNDLE_PATH']
      File.expand_path(path) # expand the tilde if necessary
    rescue
      ''
    end

    def self.print_bundle_error(e)
      puts e.message
      if File.exist?(bundle_config)
        puts 'Try running `bundle update`'
      else
        puts 'Try running `bundle install --path=%s`' % desired_bundle
      end
    end
  end
end
