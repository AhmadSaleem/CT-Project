Rails.application.routes.draw do

  require 'sidekiq/web'

  devise_for :users, controllers: { omniauth_callbacks: "users/callbacks", registrations: "users/registrations" }
  ActiveAdmin.routes(self)
  root to: 'home#index'

  resources :tournaments, only: [:index, :show] do
    collection do
      get 'team_standings'
      get 'standings'
    end
  end

  resources :teams
  resources :users, only: [:edit, :update]

  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
