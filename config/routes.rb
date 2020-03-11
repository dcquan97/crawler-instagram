Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  #dashboard
  get'/delete_account' => 'sessions#delete_account'
  get'/dashboard' => 'users#index'
controller :sessions do
  get 'login'     => :new
  post 'login'    => :create
  delete 'logout' => :destroy
  put 'profile'   => :update
  get 'profile'   => :index
  post 'crawler'  => :crawler
  get 'edit'      => :edit
end
  #router-user
  resources :users
  #router-post
  resources :posts, only: [:show,:edit]
  #homepage
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
