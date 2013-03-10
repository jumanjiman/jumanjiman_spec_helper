# vim: set ts=2 sw=2 ai et ruler:

# use the local git version of library for dev
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# library of useful (to me) utils
require 'jumanjiman_spec_helper'

# lock dependencies and load paths, but lazy-load gems
JumanjimanSpecHelper::Bundle.setup :development

# bundle skeleton
require "bundler/gem_tasks"

task :default do |t|
  puts %x!rake -T!
end
