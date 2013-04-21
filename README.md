# JumanjimanSpecHelper

[![Build Status](https://travis-ci.org/jumanjiman/jumanjiman_spec_helper.png?branch=master)](https://travis-ci.org/jumanjiman/jumanjiman_spec_helper)&emsp;[![Coverage Status](https://coveralls.io/repos/jumanjiman/jumanjiman_spec_helper/badge.png?branch=master)](https://coveralls.io/r/jumanjiman/jumanjiman_spec_helper)&emsp;[![Code Climate](https://codeclimate.com/github/jumanjiman/jumanjiman_spec_helper.png)](https://codeclimate.com/github/jumanjiman/jumanjiman_spec_helper)

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

### Git helper

`JumanjimanSpecHelper::Git` adds...

* a custom `repo_root` setting to the rspec configuration
* a custom rake task to merge `.repo/config` into `.git/config`

#### Discovery (Queries)

You may want to discover the path to a repo.

1. Add to `spec/spec_helper.rb`:

   ```ruby
   require 'jumanjiman_spec_helper/git'
   ```

2. Add to any spec:

   ```ruby
   require 'spec_helper'

   # either...
   absolute_path_to_repo = RSpec.configuration.repo_root

   # or...
   absolute_path_to_repo = JumanjimanSpecHelper::Git.repo_root
   ```

#### Configuration

Perhaps you want to ensure every clone of your repo has
a specific git configuration. You may want to ensure a
linear history within the repo or provide a commit template
to help authors use a specific local format. Specifically,
assume you want to:

* Provide a git commit template specific to the repo,
  overriding system-wide or user-default setting

* Replace `REPO_ROOT` with the actual path to the repo as it
  exists on the user's workstation ("REPO_ROOT" gets replaced)

* Set `autosetuprebase` as `always`,
  overriding system-wide or user-default setting

Steps:

1. Add to `Rakefile`:

   ```ruby
   require 'jumanjiman_spec_helper/git'

   # either merge the configs via method call...
   JumanjimanSpecHelper::Git.update_git_config

   # or add a task dependency, such as...
   task :default => 'j:update_git_config' do |t|
     # your normal default task code
   end

   # or...
   RSpec::Core::RakeTask.new(:spec => 'j:update_git_config') do |t|
     t.pattern = 'spec/*/*_spec.rb'
   end
   ```

2. Create `.repo/config` with git configuration info, such as:

   ```
   [branch]
   autosetuprebase = always # maintain linear history

   [commit]
   template = REPO_ROOT/.repo/commit.template # provide guidance
   ```

3. Create `.repo/commit.template`, such as:

   ```
   modulename: purpose
   #========= your lines should not be wider than this ============
   # modulename should be name of puppet module
   # purpose should be high-level summary
   # Use present tense: "do"; NOT "doing", "did", or "will"

   # Request for Change number, "TBD", or "not required"
   RFC:

   # Briefly describe affected nodes/environments
   Impacted area:

   More info:
   #========= your lines should not be wider than this ============
   ```
