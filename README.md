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

### Use all or parts of the gem's functionality

This gem uses [Bundler](http://gembundler.com/) for setup.
The simplest way is to `require 'jumanjiman_spec_helper'`,
which includes *all* functionality.

The other way is to include just the specific functionality
you want or need. The sections below assume you want to use
targeted functionality. Each example demonstrates how to include
and activate the specific functionality for each example.

### Bundler

This gem can wrap bundler functionality. If you want your
`Rakefile` to bundle gem dependencies, the easiest way is to
add at the top of your `Rakefile`:

```ruby
require 'bundler/setup'
require 'jumanjiman_spec_helper/bundle'
# lazy-load default gem environment
JumanjimanSpecHelper::Bundle.setup
```

With the above code in place, it will suggest the correct bundler
commands whenever gem dependencies need to be updated according
to the Gemfile or gemspec in your project. The default action
shown above is to use `Bundler.setup :default`, which locks
dependencies and load paths, but delays loading any given gem
until it is actually required. This speeds startup time.
I call this *lazy-loading*.

An alternative is to *early-load* all gems at startup time.
To early-load your gems, use:

```ruby
require 'bundler/setup'
require 'jumanjiman_spec_helper/bundle'
# early-load default gem environment
JumanjimanSpecHelper::Bundle.setup :default, true
```

You can also specify different gem groups, such as:

```ruby
require 'bundler/setup'
require 'jumanjiman_spec_helper/bundle'
# early-load development gem environment
JumanjimanSpecHelper::Bundle.setup :development, true
```

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
