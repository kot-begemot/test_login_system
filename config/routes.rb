TestLoginSystem::Application.routes.draw do
  get "main/index"
  get "main/welcome"

  resources :users, only: [:new, :create]

  get 'register' => 'users#new'
  post 'register' => 'users#create'

  get 'login' => 'session#new'
  post 'login' => 'session#create'
  get 'logout' => 'session#destroy'

  root :to => 'main#index'
end
