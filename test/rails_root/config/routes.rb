ActionController::Routing::Routes.draw do |map|
  
  map.root :controller => 'default', :action => 'index'
  
  map.resources :users, :has_one => :profile

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
