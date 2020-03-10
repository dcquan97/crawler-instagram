Rails.application.routes.draw do
  #dashboard
  get '/dashboard' => 'users#index'
  controller :sessions do
    get 'login'     => :new
    post 'login'    => :create
    put 'profile'   => :update
    get 'profile'   => :edit
    delete 'logout' => :destroy
  end
  #router-user
  resources :users
  #router-post
  resources :post
  # Password Reset and Password forgot
  resources :password
  # Sidekiq Routes
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  #homepage
  root 'home#index'
end
