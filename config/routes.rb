ActionController::Routing::Routes.draw do |map|
  SprocketsApplication.routes(map)
  map.javascript '/javascripts/:action.js', :controller => 'javascripts', :format => :js

	map.resources :observations
	map.range '/observations/range/:range_begin/:range_end/:granularity.:format',
	  :controller => 'observations',
	  :action => 'range',
	  :requirements => { :granularity => /#{ObservationsController::GRANULARITIES.keys.join('|')}/ }
  map.changelog '/changelog.:format', :controller => 'observations', :action => 'changelog'
  map.todo '/todo.:format', :controller => 'observations', :action => 'todo'
  
  map.root :controller => 'observations'


  map.signup '/signup', :controller => 'users', :action => 'create', :conditions => { :method => :post}
  map.signup '/signup', :controller => 'users', :action => 'new', :conditions => { :method => :get}
  map.resource :account, :controller => 'users'
  map.login '/login', :controller => 'user_sessions', :action => 'create', :conditions => { :method => :post}
  map.login '/login', :controller => 'user_sessions', :action => 'new', :conditions => { :method => :get}
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  
end
