Rails.application.routes.draw do

  # profiles
  resources :profiles, :controller => 'muck/profiles' do
    collection do
      get :search
    end
  end
  
  resources :users do
    resource :profile, :controller => 'muck/profiles'
  end
  
  namespace :admin do
    resources :profiles, :controller => 'muck/profiles'
  end
    
end
