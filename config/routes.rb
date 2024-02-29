Rails.application.routes.draw do
  resources :abouts 
  resources :contacts
  resources :user_applications do
    member do
      get :delete
    end
  end

  resources :users do
    member do
      get :delete
      patch :update_role
    end
  end

  resources :officer_applications do
    member do
      get :delete
    end
  end

  resources :application_notes do
    member do
      get :delete
    end
  end

  resources :cars
  resources :car_types
  resources :parts
  root to: 'main#index'

  # root to: 'dashboards#show'
  get 'dashboard', to: 'dashboards#show', as: 'dashboard'
  get 'dashboard/members_table', to:'dashboards#show_table_users', as: 'table_users_view'

  devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }
  devise_scope :admin do
    get 'admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    get 'admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
  end

  get 'main/index', to:'main#index', as:'home'

end
