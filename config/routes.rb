Rails.application.routes.draw do
  devise_for :users
  root to: 'home#home'
  
  get   'my_inn',                     to: 'inns#my_inn',                 as: 'my_inn'
  patch 'my_inn/status',              to: 'inns#change_status',          as: 'status_inn'
  get   'my_inn/edit',                to: 'inns#edit',                   as: 'edit_inn'
  get   'my_inn/aditional/edit/:id',  to: 'inn_additionals#edit',         as: 'edit_inn_additional' 
  
  resources :inns, only: [:new, :create, :show, :update]  
  resources :inn_additionals, only: [:update]
  resources :payment_methods, only: [:new, :create, :edit, :update, :destroy]
  resources :rooms, only: [:new, :create, :edit, :update] do
    patch 'status', to: 'rooms#change_status', as: 'status'
  end
end
