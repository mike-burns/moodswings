ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'pages', :action => 'home'
  map.home '/dashboard', :controller => 'pages', :action => 'dashboard'
  map.resource :session
  map.resource :account
  map.resource :openid
  map.resources :users do |user|
    user.resource :subscription, :only => [:destroy,:create]
  end
  map.resources :moods
end
