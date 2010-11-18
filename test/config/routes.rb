RailsTest::Application.routes.draw do
  root :to => "default#index"
  resources :users
  match ':controller(/:action(/:id(.:format)))'
end