Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get '/items/:id/merchant', to: 'item_merchant#show'
      get '/merchants/find', to: 'merchants#find'
      get '/merchants/find_all', to: 'merchants#find_all'
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index, :show]
      end
      get '/items/find', to: 'items#find'
      get '/items/find_all', to: 'items#find_all'
      resources :items
      get '/revenue/merchants', to: 'revenue#top'
      get '/revenue/unshipped', to: 'revenue#unshipped'
      resources :revenue, only: [:index]
    end
  end
end
