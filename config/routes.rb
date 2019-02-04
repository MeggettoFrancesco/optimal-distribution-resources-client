Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  require 'sidekiq/web'
  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :requests, only: %i[index new create show]
  root 'requests#index'
end
