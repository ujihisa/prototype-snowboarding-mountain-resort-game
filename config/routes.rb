Rails.application.routes.draw do
  resources :rides
  root 'rides#index'
end
