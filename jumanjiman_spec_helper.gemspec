# -*- encoding: utf-8 -*-
# vim: set ts=2 sw=2 ai et ruler syntax=ruby:
#
# This gemspec was created with `bundle gem jumanjiman_spec_helper'
# http://net.tutsplus.com/tutorials/ruby/gem-creation-with-bundler/
#
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jumanjiman_spec_helper/version'

# http://rubygems.rubyforge.org/rubygems-update/Gem/Specification.html
Gem::Specification.new do |gem|
  gem.name          = "jumanjiman_spec_helper"
  gem.version       = JumanjimanSpecHelper::VERSION
  gem.authors       = ["Paul Morgan"]
  gem.email         = ["jumanjiman@gmail.com"]
  gem.description   = %q{Puppet spec helper and common rspec tests}
  gem.summary       = %q{Provides common rspec tests for Puppet modules}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # http://docs.rubygems.org/read/chapter/20#development_dependencies
  gem.add_development_dependency 'rake', '>= 10.0'
  gem.add_development_dependency 'rspec-core', '2.12.2'
  gem.add_development_dependency 'rspec', '2.12.0'
  gem.add_development_dependency 'rspec-expectations', '2.12.1'
  gem.add_development_dependency 'rspec-mocks', '2.12.2'
  # https://github.com/freerange/mocha#bundler
  gem.add_development_dependency 'minitest', '4.5.0'
  gem.add_development_dependency 'mocha', '0.13.2'
end
