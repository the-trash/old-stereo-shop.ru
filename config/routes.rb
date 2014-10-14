Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root 'welcome#index'

  resources :product_categories, only: :show do
    get :sale, on: :collection
  end

  resources :products, only: [:index, :show] do
    member do
      post :add_review
    end
  end

  resources :post_categories, only: :show
  resources :posts, only: :show

  resources :users, except: [:destroy] do
    collection do
      get :authentification
    end
  end
end
