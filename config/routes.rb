require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == 'admin' && password == 'admin'
end

Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/admin/sidekiq'
  mount AdminApp::Engine => '/administration', as: :admin_app

  # get '/page_404'  => 'app_errors#page_404', as: :page_404
  %w[ bug detect_403 detect_404 detect_422 detect_500 ].each do |page|
    get page => "app_errors##{ page }"
  end

  resources :yandex_market_lists do
    collection do
      get :export
      match :elco_check, via: %w[ get post ]
      match :elco_import_start, via: %w[ get post ]
    end

    put :switch
    patch :product_update
  end

  devise_for :users,
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }

  # TODO add authenticate layout and remove activeadmin config
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # TODO transfer it into new admin_app after finishing admin_app
  # namespace :admin do
  #   authenticate :admin_user do

  #   end
  # end

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

    collection do
      get :success_complete
      post :in_one_click
    end
  end

  resources :payments, only: [] do
    collection do
      post :check
      post :status
      get :fail
      get :success
    end
  end

  resources :products, only: [:index, :show] do
    member do
      get :more_review
    end

    resources :wishlists, only: [:create, :destroy]
    resources :additional_options, only: :show, module: :product
  end

  resources :reviews, only: [:index, :create]

  %i(post_categories posts stores).each do |resource|
    resources resource, only: :show
  end

  resources :feedbacks, only: [:create] do
    post :call_me, on: :collection
  end

  resources :pages, only: :show

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
