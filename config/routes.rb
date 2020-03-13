Rails.application.routes.draw do
  #dashboard
  get'/delete_account' => 'sessions#delete_account'
  get'/dashboard' => 'users#index'
  controller :sessions do
    get 'login'     => :new
    post 'login'    => :create
    delete 'logout' => :destroy
    put 'profile'   => :update
    get 'profile'   => :edit
    post 'crawler'  => :crawler
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
