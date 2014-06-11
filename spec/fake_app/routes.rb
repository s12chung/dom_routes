FakeApp::Application.routes.draw do
  resources :users, :only => [:index] do
    collection do
      get :with_parameters
    end
  end
  resources :admins, :only => [:index] do
    collection do
      get :with_parameters
    end
  end
  resources :artists, :only => [:index]

  namespace :dashboard do
    resources :users, :only => [:index] do
      collection do
        get :with_parameters
      end
    end
  end
end