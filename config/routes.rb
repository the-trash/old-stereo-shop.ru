require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }

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
      get :remove_from_wishlist
      get :new_review
      get :more_review
    end
  end

  %i(post_categories posts).each do |resource|
    resources resource, only: :show
  end

  resources :pages, only: :show do
    post :feedback
  end

  resources :brands, only: [:index, :show]

  resources :users, except: [:destroy, :edit] do
    member do
      get :you_watched
      get :wishlist

      scope :settings, controller: 'users/settings', path: :settings do
        get :profile, as: :settings_profile
        get :mail, as: :settings_mail
        get :password, as: :settings_password
        get :subscriptions, as: :settings_subscriptions
      end
    end
  end
end
