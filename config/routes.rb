Rails.application.routes.draw do
  resources :users
  resources :movies
  resources :cinemas
  resources :assignments
  resources :seats

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'


  # Defines the root path route ("/")
  root "cinemas#index"
end
