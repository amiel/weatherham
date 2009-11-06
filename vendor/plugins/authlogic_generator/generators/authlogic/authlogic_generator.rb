require File.expand_path(File.dirname(__FILE__) + "/lib/insert_routes.rb")

class AuthlogicGenerator < Rails::Generator::Base
  default_options :use_haml  => false,
                  :use_rspec => false

  def manifest
    template = options[:use_haml] ? 'haml' : 'erb'

    record do |m|
      
      # COPY FILES
      # app/controllers
      m.file('app/controllers/user_sessions_controller.rb', 'app/controllers/user_sessions_controller.rb')
      m.file('app/controllers/users_controller.rb', 'app/controllers/users_controller.rb')      

      # app/models
      m.file('app/models/user_session.rb', 'app/models/user_session.rb')
      m.file('app/models/user.rb', 'app/models/user.rb')      

      # app/views
      m.directory('app/views/user_sessions')
      m.file("app/views/user_sessions/new.html.#{template}", "app/views/user_sessions/new.html.#{template}")
      m.directory('app/views/users')
      m.file("app/views/users/_form.html.#{template}", "app/views/users/_form.html.#{template}")
      m.file("app/views/users/edit.html.#{template}", "app/views/users/edit.html.#{template}")
      m.file("app/views/users/new.html.#{template}", "app/views/users/new.html.#{template}")
      m.file("app/views/users/show.html.#{template}", "app/views/users/show.html.#{template}")

      # lib
      m.file('lib/authentication_handling.rb', 'lib/authentication_handling.rb')

      if options[:use_rspec]
        # spec/fixtures
        m.directory('spec/fixtures')
        m.file('test/fixtures/users.yml', 'spec/fixtures/users.yml')

        # spec/controllers
        m.directory('spec/controllers')
        m.file('spec/controllers/user_sessions_controller_spec.rb', 'spec/controllers/user_sessions_controller_spec.rb')
        m.file('spec/controllers/users_controller_spec.rb', 'spec/controllers/users_controller_spec.rb')

        # spec/models
        m.directory('spec/models')
        m.file('spec/models/user_session_spec.rb', 'spec/models/user_session_spec.rb')
        m.file('spec/models/user_spec.rb', 'spec/models/user_spec.rb')

      else
        # test/fixtures
        m.file('test/fixtures/users.yml', 'test/fixtures/users.yml')

        # test/functional
        m.file('test/functional/user_sessions_controller_test.rb', 'test/functional/user_sessions_controller_test.rb')
        m.file('test/functional/users_controller_test.rb', 'test/functional/users_controller_test.rb')      

        # test/unit
        m.file('test/unit/user_session_test.rb', 'test/unit/user_session_test.rb')
        m.file('test/unit/user_test.rb', 'test/unit/user_test.rb')      
      end

      # Include authentication handling module in application controller
      m.edit_file('/app/controllers/application_controller.rb', 'class ApplicationController < ActionController::Base', 'include AuthenticationHandling')
      
      # CREATE ROUTES    
      # user sessions
      m.route_name('logout', '/logout', { :controller => "user_sessions", :action => 'destroy' } )
      m.route_name('login', '/login', { :controller => "user_sessions", :action => 'new', :conditions => { :method => :get }} )
      m.route_name('login', '/login', { :controller => "user_sessions", :action => 'create', :conditions => { :method => :post }})

      # user
      m.route_resource('account', :controller => "users")
      m.route_name('signup', '/signup', {:controller => "users", :action => "new", :conditions => { :method => :get }})
      m.route_name('signup', '/signup', {:controller => "users", :action => "create", :conditions => { :method => :post }})        
      
      # CREATE DATABASE MIGRATIONS
      m.migration_template "db/migrate/create_users.rb", "db/migrate", :migration_file_name => 'create_users'
      
      # Show Readme
      m.readme "../INSTALL"
    end
  end

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--haml", "Use Haml view templates") { |v| options[:use_haml] = true }
    opt.on("--rspec", "Generate specs instead of tests") { |v| options[:use_rspec] = true }
  end
end
