ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'pages', :action => 'home'
  map.resource :session
  map.resource :account
  map.resource :openid
  map.resources :users
  map.resources :moods
end
