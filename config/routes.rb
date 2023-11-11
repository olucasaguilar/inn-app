Rails.application.routes.draw do
  devise_for :users
  root to: 'home#home'

  resources :inns, only: [:new, :create, :update, :show] do
    get 'city', on: :collection
    get 'search', on: :collection
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
end