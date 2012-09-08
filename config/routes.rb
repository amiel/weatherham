Weatherham::Application.routes.draw do
  get "observations/index"

 # match '/javascripts/:action.js' => 'javascripts#index', :as => :javascript, :format => :js
  resources :observations do
    collection do
      get :statistics
    end
  end

  match '/observations/range/:range_begin/:range_end/:granularity.:format' => 'observations#range',
      as: :range, constraints: { granularity: /five_min|hourly|six_hour|daily/ }
  match '/changelog(.:format)' => 'pages#changelog', as: :changelog
  match '/todo(.:format)' => 'pages#todo', as: :todo
  match '/about(.:format)' => 'pages#about', as: :about

  root to: 'observations#index'

end
