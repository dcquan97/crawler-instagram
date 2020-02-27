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
  get 'password/new', to: 'password#new'
  post 'password/forgot', to: 'password#forgot'
  post 'password/reset', to: 'password#reset'
  #homepage
  root 'home#index'
end
