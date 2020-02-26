Rails.application.routes.draw do
  #dashboard
  get'/dashboard' => 'dashboard#index'
  #router-user
  resources :users
  #homepage
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
