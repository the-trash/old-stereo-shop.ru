require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :admin do
    authenticate :admin_user do
      mount Sidekiq::Web, at: '/sidekiq'
    end
  end

  root 'welcome#index'

  resources :product_categories, only: :show do
    get :sale, on: :collection
    get :sale, on: :member, action: :sale_product_category
  end

  resources :products, only: [:index, :show] do
    member do
      post :add_review
      post :add_to_wishlist
      get :new_review
      get :more_review
    end
  end

  %i(post_categories posts pages).each do |resource|
    resources resource, only: :show
  end

  resources :brands, only: [:index, :show]

  resources :users, except: [:destroy, :edit, :update] do
    collection do
      get :profile, action: :edit
      post :profile, action: :update
      get :wishlist, action: :wishlist
    end
  end
end
