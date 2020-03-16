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
  resources :posts, only: [:show,:update]
  # Payment method with stripe
  resources :billing, only: [:index, :new, :create]
  get '/card/new' => 'billing#new_card', as: :add_payment_method
  post '/card'    => 'billing#create_card', as: :create_payment_method
  get '/success'  => 'billing#success', as: :success
end
