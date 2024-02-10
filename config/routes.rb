Rails.application.routes.draw do
  get 'main/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "main#index"
  resources :cars
  resources :car_types
  # Defines the root path route ("/")
  # root "articles#index"
end
