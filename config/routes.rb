Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Rails health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do

      resources :users, only: %i[index show update destroy]

      resources :books, only: [:index, :show] do
        resources :reviews, only: [:create, :index]
      end

      resources :borrowings, only: [:create] do
        resources :renewal_requests, only: [:create]
        
        member do
          post :return
        end

        collection do
          get :history
        end
      end

      post '/auth/login', to: 'auth#login'
      post '/auth/register', to: 'auth#register'
    end
  end
end
