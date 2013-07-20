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

  # == Dependencies ==
  # http://guides.rubygems.org/patterns/
  # http://docs.rubygems.org/read/chapter/20#dependencies
  # http://docs.rubygems.org/read/chapter/20#development_dependencies

  # these are needed for both dev and runtime
  common_dependencies = {
    'inifile' => '~> 2.0.2', # https://github.com/TwP/inifile
    'minigit' => '~> 0.0.4', # https://github.com/3ofcoins/minigit
    'rake'    => '>= 10.0',
    'rspec'   => '2.12.0',
  }
  common_dependencies.each do |dep, ver|
    gem.add_dependency             dep, ver
    gem.add_development_dependency dep, ver
  end

  # these are only needed for dev
  gem.add_development_dependency 'rake', '>= 10.0'
  gem.add_development_dependency 'rspec-core', '2.12.2'
  gem.add_development_dependency 'rspec-expectations', '2.12.1'
  gem.add_development_dependency 'rspec-mocks', '2.12.2'
  # https://github.com/freerange/mocha#bundler
  gem.add_development_dependency 'minitest', '4.5.0'
  gem.add_development_dependency 'mocha', '0.13.2'

  # https://coveralls.io/docs/ruby
  gem.add_development_dependency 'coveralls'

  # -----------------------------------------------------------------
  # documentation gems similar to http://rubydoc.info/

  # see .yardopts and http://yardoc.org/
  gem.add_development_dependency 'yard'

  # enable gfm special features, such as tables in markdown
  gem.add_development_dependency 'github-markup'

  # redcarpet 2.x series does not play nicely with github-markup
  gem.add_development_dependency 'redcarpet', '~> 1.0'

  # plugin to auto-document rspec tests
  gem.add_development_dependency 'yard-rspec'

  # do not use tomdoc; it's visually nice in plain-text,
  # but it doesn't render as nicely as redcarpet + yard tags
  #gem.add_development_dependency 'yard-tomdoc'

  # end documentation gems
  # -----------------------------------------------------------------
end
