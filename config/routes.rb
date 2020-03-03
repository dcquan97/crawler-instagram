Rails.application.routes.draw do
  #dashboard
  get'/dashboard' => 'users#index'
  get'/login' => 'sessions#index'
  post'/login' => 'sessions#create'
  get '/profile'=> 'sessions#edit'
  delete '/logout' => 'sessions#destroy'
  #router-user
  resources :users
  # Password Reset and Password forgot
  resources :password
  # Sidekiq Routes
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  #homepage
  root 'home#index'
end
