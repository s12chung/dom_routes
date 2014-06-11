FakeApp::Application.routes.draw do
  resources :users, :only => [:index]
  resources :admins, :only => [:index]
  resources :artists, :only => [:index]
end