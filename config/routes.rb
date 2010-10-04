ActionController::Routing::Routes.draw do |map|

  # profiles
  resources :profiles, :controller => 'muck/profiles' do
    collection do
      get :search
    end
  end
  
  resources :users, :has_one => :profile
  
  namespace :admin do
    resources :profiles, :controller => 'muck/profiles'
  end
    
end
