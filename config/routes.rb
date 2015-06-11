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

  resources :cities, only: [:index, :show]

  resources :product_categories, only: :show do
    get :sale, on: :collection
    get :sale, on: :member, action: :sale_product_category
  end

  resources :carts, except: [:index, :edit, :new]
  resources :line_items, only: [:create, :update, :destroy]
  resources :orders, only: [:create, :update, :show] do
    member do
      get :delivery
      get :authentification
      get :payment
      get :complete
    end

    get :success_complete, on: :collection
  end

  resources :payments, only: [] do
    collection do
      post :check
      post :status
    end
  end

  resources :products, only: [:index, :show] do
    member do
      post :add_review
      get :new_review
      get :more_review
    end

    resources :wishlists, only: [:create, :destroy]

    scope module: 'product' do
      resources :additional_options, only: :show
    end
  end

  %i(post_categories posts stores).each do |resource|
    resources resource, only: :show
  end

  resources :pages, only: :show do
    post :feedback
  end

  resources :brands, only: [:index, :show]

  resources :subscribed_emails, only: [:create, :destroy]

  resources :users, except: [:destroy, :edit] do
    member do
      get :you_watched

      scope :settings, controller: 'users/settings', path: :settings do
        get :profile, as: :settings_profile
        get :mail, as: :settings_mail
        get :password, as: :settings_password
        get :subscriptions, as: :settings_subscriptions
      end
    end

    resources :wishlists, only: :index
  end
end
