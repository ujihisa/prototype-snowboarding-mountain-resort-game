Rails.application.routes.draw do
  resources :rides, except: :index
  root to: 'rides#index'
end
