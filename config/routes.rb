Rails.application.routes.draw do
  devise_for :users

  resources :books do
    collection do
      get :search
      get :dashboard
    end

    member do
      post :borrow
    end
  end

  resources :borrowings

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  root "books#index"
end
