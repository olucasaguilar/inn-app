Rails.application.routes.draw do
  devise_for :users
  root to: 'home#home'

  resources :inns, only: [:new, :create, :update, :show] do
    get 'city', on: :collection
    get 'search', on: :collection
    
    resources :rooms do
      resources :reservations, only: [:new, :create, :show] do
        post 'validate', on: :collection
        get 'confirm', on: :collection
        post 'canceled', on: :member
        
        resources :reviews, only: [:new, :create]
      end
    end
    
    resources :reviews, only: [:index]
  end

  resources :reservations, only: [:index]

  namespace :innkeeper do
    resources :reviews, only: [:index, :edit, :update]
    
    resources :reservations, only: [:index, :show] do
      post 'active', on: :member
      get 'active', on: :collection, to: 'reservations#active_reservations'
      post 'canceled', on: :member
      get 'check_out', on: :member
      patch 'finished', on: :member
    end
  end

  scope 'inns/search' do
    get 'advanced',            to: 'advanced_searches#search',     as: 'advanced_search_inns'
    get 'advanced/results',    to: 'advanced_searches#results',    as: 'advanced_search_inns_results'
  end
  
  scope 'my_inn/' do
    get       '/',                    to: 'inns#my_inn',            as: 'my_inn'
    patch     '/status',              to: 'inns#change_status',     as: 'status_inn'
    get       '/edit',                to: 'inns#edit',              as: 'edit_inn'
    get       '/aditional/:id/edit',  to: 'inn_additionals#edit',   as: 'edit_inn_additional'
    patch     '/aditional/:id',       to: 'inn_additionals#update', as: 'inn_additional'
    
    resources :rooms, only: [:new, :create, :edit, :update, :show] do
      patch 'status', to: 'rooms#change_status', as: 'status'
    end

    scope 'room/:room_id' do
      resources :price_periods, only: [:index, :new, :create, :update, :destroy, :edit]
    end

    resources :payment_methods, only: [:new, :create, :edit, :update, :destroy]
  end

  scope :users do
    resources :guest_users, only: [:edit, :update]
  end

  namespace :api do
    namespace :v1 do
      resources :inns, only: [:index, :show] do
        resources :rooms, only: [:index] do
          get 'availability', on: :member
        end
      end
    end
  end
end