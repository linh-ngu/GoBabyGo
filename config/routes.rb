Rails.application.routes.draw do
  resources :user_applications do
    member do
      get :delete
    end
  end
  get 'main/index'
  root "main#index"
  resources :cars
  resources :car_types
  resources :parts
end

