IDEAL_CONSOLE_WIDTH = 72
def horizontal_rule(width = 5)
  '=' * [width, IDEAL_CONSOLE_WIDTH].min
end

# use the local git version of library for dev
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# common dependencies
gems = [
  'test/unit',   # https://github.com/freerange/mocha#bundler
  'mocha/setup', # http://gofreerange.com/mocha/docs/Mocha/Configuration.html
  'jumanjiman_spec_helper',
]
begin
  gems.each {|gem| require gem}
rescue Exception => e
  # emphasize dependency failures in case a task spews lots of output
  puts horizontal_rule(e.message.length)
  puts e.message
  puts horizontal_rule(e.message.length)
  exit(1)
end

RSpec.configure do |c|
  # https://www.relishapp.com/rspec/rspec-core/v/2-12/docs/mock-framework-integration/mock-with-mocha!
  c.mock_framework = :mocha

  # see output for all failures
  c.fail_fast = false

  # show times for 10 slowest examples (unless there are failed examples)
  c.profile_examples = true
end
