Rails.application.routes.draw do
  devise_for :users
  root to: 'home#home'

  resources :inns, only: [:new, :create, :update, :show]
  
  scope 'my_inn/' do
    get       '/',                    to: 'inns#my_inn',            as: 'my_inn'
    patch     '/status',              to: 'inns#change_status',     as: 'status_inn'
    get       '/edit',                to: 'inns#edit',              as: 'edit_inn'
    get       '/aditional/edit/:id',  to: 'inn_additionals#edit',   as: 'edit_inn_additional'
    patch     '/aditional/:id',       to: 'inn_additionals#update', as: 'inn_additional'
    
    resources :rooms, only: [:new, :create, :edit, :update, :show] do
      patch 'status', to: 'rooms#change_status', as: 'status'
      resources :price_periods, only: [:index]
    end

    resources :payment_methods, only: [:new, :create, :edit, :update, :destroy]
  end
end
