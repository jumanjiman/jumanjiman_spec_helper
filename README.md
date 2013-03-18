# JumanjimanSpecHelper

[![Build Status](https://travis-ci.org/jumanjiman/jumanjiman_spec_helper.png?branch=master)](https://travis-ci.org/jumanjiman/jumanjiman_spec_helper)

This gem provides reusable components that can be helpful when
writing rspec for [Puppet](https://puppetlabs.com/puppet/what-is-puppet/)
modules.

## Installation

Add this line to your application's Gemfile:

    gem 'jumanjiman_spec_helper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jumanjiman_spec_helper

## Usage

### Shared contexts

#### Environment variables

Environment variables created in one rspec example can invalidate
other examples, giving either false positives or false failures.

The default rspec configuration shows three behaviors:

* Preserve environment variables that exist *before* rspec examples
* Clobber environment variables modified *within* rspec examples
* Preserve environment variables created *within* rspec examples

This module cleans up your environment between examples:

* Preserve environment variables that exist *before* rspec examples
* Restore environment variables modified *within* rspec examples
* Discard environment variables created *within* rspec examples

Add to `spec/spec_helper.rb`:

```ruby
require 'jumanjiman_spec_helper/environment_context'
RSpec.configure do |c|
  # your normal config
  c.include JumanjimanSpecHelper::EnvironmentContext
end
```

That's it! Now environment variables are automatically
cleaned up between rspec examples.
