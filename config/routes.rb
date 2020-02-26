Rails.application.routes.draw do

  #dashboard
  get'/dashboard' => 'users#index'

  resources :users

  root 'home#index'
  resources :user
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
