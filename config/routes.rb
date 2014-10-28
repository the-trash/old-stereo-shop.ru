Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'welcome#index'

  resources :product_categories, only: :show do
    get :sale, on: :collection
  end

  resources :products, only: [:index, :show] do
    member do
      post :add_review
      post :add_to_wishlist
      get :new_review
      get :more_review
    end
  end

  resources :post_categories, only: :show
  resources :posts, only: :show

  resources :users, except: [:destroy, :edit, :update] do
    collection do
      get :authentification
      get :profile, action: :edit
      post :profile, action: :update
      get :wishlist, action: :wishlist
    end
  end
end
