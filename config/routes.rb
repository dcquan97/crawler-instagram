Rails.application.routes.draw do
  #dashboard
  get'/dashboard' => 'users#index'
  get'/login' => 'sessions#index'
  post'/login' => 'sessions#create'
  get '/profile'=> 'sessions#edit'
  delete '/logout' => 'sessions#destroy'
  #router-user
  resources :users
  #homepage
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
