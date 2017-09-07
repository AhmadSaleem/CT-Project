Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: "users/callbacks", registrations: "users/registrations" }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'teams#index'


  resources :teams
  resources :users, only: [:edit, :update]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
