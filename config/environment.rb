# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'jeffrafter-spreadhead', :lib => 'spreadhead', :source => 'http://gems.github.com'
  config.gem 'sprockets'
  config.gem 'justinfrench-formtastic', :lib => 'formtastic', :source => 'http://gems.github.com'
  config.gem 'authlogic'
  config.gem 'less'
  config.gem 'will_paginate'

  config.time_zone = 'Pacific Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :en
end
