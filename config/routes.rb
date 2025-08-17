# frozen_string_literal: true

Rails.application.routes.draw do
  root 'admin/accounts#index'
  get 'admin', to: redirect('/admin/accounts')

  namespace :admin do
    resources :accounts, :products, :users
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
