RailsTest::Application.routes.draw do
  root :to => "default#index"
  resources :users, :has_one => :profile
  match ':controller(/:action(/:id(.:format)))'
end