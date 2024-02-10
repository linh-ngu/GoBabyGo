Rails.application.routes.draw do
  resources :user_applications do
    member do
      get :delete
    end
  end
  get 'main/index'
  root "main#index"
end
#test change
