# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.11' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'jeffrafter-spreadhead', :version => '=0.6.2', :lib => 'spreadhead', :source => 'http://gems.github.com'
  config.gem 'sprockets', :version => '=1.0.2'
  config.gem 'justinfrench-formtastic', :version => '=0.2.4', :lib => 'formtastic', :source => 'http://gems.github.com'
  config.gem 'authlogic', :version => '=2.1.2'
  # config.gem 'less'
  config.gem 'will_paginate', :version => '=2.3.11'

  config.time_zone = 'Pacific Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :en
end
