ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'pages', :action => 'home'
  map.resource :session
  map.resource :account
  map.openid '/openid', :controller => 'openids', :action => 'update', :conditions => {:method => :put}
  map.show_openid '/openid', :controller => 'openids', :action => 'show', :conditions => {:method => :get}
end
