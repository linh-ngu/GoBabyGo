Rails.application.routes.draw do
  resources :user_applications do
    member do
      get :delete
    end
  end

  resources :users do
    member do
      get :delete
    end
  end

  resources :officer_applications do
    member do
      get :delete
    end
  end

  
  resources :parts do
    member do
      get :delete
    end
  end
  get 'inventory', to: 'main#inventory', as: 'inventory'

  
  resources :cars do
    member do
      get :delete
    end
  end

  resources :car_types do
    member do
      get :delete
    end
  end

  resources :notes do
    member do
      get :delete
    end
  end
  root to: 'main#index'

  # root to: 'dashboards#show'
  get 'dashboard', to: 'dashboards#show', as: 'dashboard'

  devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }
  devise_scope :admin do
    get 'admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    get 'admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
  end

  get 'main/index', to:'main#index', as:'home'

end
