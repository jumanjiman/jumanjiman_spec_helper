# vim: set ts=2 sw=2 ai et ruler:
module JumanjimanSpecHelper
  module EnvironmentContext
    require 'rspec/core'
    extend RSpec::SharedContext
    before :each do
      # Store environment variables (to be restored later)
      @env = Hash.new
      ENV.each {|k,v| @env[k] = v}
    end

    after :each do
      # Restore environment variables
      @env.each {|k,v| ENV[k] = v}

      # remove environment vars that did not exist before test
      ENV.keys.reject{|k| @env.include?(k)}.each{|k| ENV.delete(k)}
    end
  end
end
