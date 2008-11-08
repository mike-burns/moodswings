PROJECT_NAME = "moodswings"

throw "The project's name in environment.rb is blank" if PROJECT_NAME.empty?
throw "Project name (#{PROJECT_NAME}) must_be_like_this" unless PROJECT_NAME =~ /^[a-z_]*$/

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'mislav-will_paginate', 
             :lib => 'will_paginate', 
             :source => 'http://gems.github.com', 
             :version => '~> 2.3.5'

  config.gem "ruby-openid", :lib => 'openid'

  config.gem 'thoughtbot-shoulda', 
    :lib => 'shoulda',
    :source => 'http://gems.github.com',
    :version => '>= 2.0.5'
  config.gem 'thoughtbot-factory_girl', 
    :lib => 'factory_girl', 
    :source => 'http://gems.github.com',
    :version => '>= 1.1.3'
  config.gem 'redgreen'

  # Add the vendor/gems/*/lib directories to the LOAD_PATH
  config.load_paths += Dir.glob(File.join(RAILS_ROOT, 'vendor', 'gems', '*', 'lib'))

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'

  SESSION_KEY = "bb64b687bf0cb57289f9161a45f1ebf7" 
  config.action_controller.session = {
    :session_key => "_#{PROJECT_NAME}_session",
    :secret      => SESSION_KEY
  }
end
