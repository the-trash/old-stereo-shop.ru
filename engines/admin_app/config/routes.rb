AdminApp::Engine.routes.draw do
  devise_for :admin_users,
    controllers: {
      sessions: 'admin_devise/sessions',
      registrations: 'admin_devise/registrations'
    }

  root to: 'welcome#index'

  resources :products, except: :show
  resources :brands, except: :show
  resources :product_categories, except: :show
  resources :stores, except: :show
  resources :characteristic_categories, except: :show
  resources :characteristics, except: :show
  resources :product_imports, except: [:destroy, :show]
  resources :yandex_market_exports, only: [:index, :new]

  resources :posts, except: :show
  resources :post_categories, except: :show
  resources :pages, except: :show
  resources :newletters, except: :show

  resources :orders, except: :show
  resources :payment_transactions, only: [:index, :show]

  resources :cities, except: :show
  resources :regions, except: :show

  resources :users, except: :show
  resources :admin_users, except: :show

  resources :settings, except: :show
  resources :seo_settings, except: :show
end
