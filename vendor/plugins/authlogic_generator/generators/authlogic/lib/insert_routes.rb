Rails::Generator::Commands::Create.class_eval do
  
  def edit_file(file, matcher, replace)
    logger.alter_file "Inserting '#{replace}' into #{file}"
    gsub_file file, /(#{Regexp.escape(matcher)})/mi do |match|
      "#{match}\n  #{replace}"
    end
  end

  def route_name(name, path, route_options = {})
    sentinel = 'ActionController::Routing::Routes.draw do |map|'
    conditions = ", :conditions => { :method => :#{route_options[:conditions][:method]}}" if route_options[:conditions]
    
    logger.route "map.#{name} '#{path}', :controller => '#{route_options[:controller]}', :action => '#{route_options[:action]}'#{conditions}"
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n  map.#{name} '#{path}', :controller => '#{route_options[:controller]}', :action => '#{route_options[:action]}'#{conditions}"
      end
    end
  end
  
  def route_resource(resource, route_options = {})
    sentinel = 'ActionController::Routing::Routes.draw do |map|'

    logger.route "map.resource :#{resource}, :controller => '#{route_options[:controller]}'"
    
    unless options[:pretend]
      gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n  map.resource :#{resource}, :controller => '#{route_options[:controller]}'\n"
      end
    end
  end
end