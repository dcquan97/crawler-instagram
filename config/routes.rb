Rails.application.routes.draw do
  #dashboard
  get'/delete_account' => 'users#show'
  get'/dashboard' => 'sessions#index'
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
  # Password Reset and Password forgot
  resources :password
  # Sidekiq Routes
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root 'home#index'
  #router-post
  resources :posts, only: [:show,:edit]
end
