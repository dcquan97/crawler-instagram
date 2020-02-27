Rails.application.routes.draw do
  #dashboard
  get'/dashboard' => 'users#index'

controller :sessions do
  get 'login'     => :new
  post 'login'    => :create
  delete 'logout' => :destroy
  put 'profile'   => :update
  get 'profile'   => :edit
end
  #router-user
  resources :users
  #homepage
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
