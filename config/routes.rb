Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: "users/callbacks" }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'teams#index'


  resources :teams
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
