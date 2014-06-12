FakeApp::Application.routes.draw do
  resources :users, :only => [:index] do
    collection do
      get :with_parameters
      get :manually_execute
      get :different_route
      get :redirect
    end
  end

  namespace :dashboard do
    resources :users, :only => [:index] do
      collection do
        get :with_parameters
      end
    end
  end
end