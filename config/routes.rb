Rails.application.routes.draw do
  get 'welcome/index'
  resources :books
  resources :authors
  devise_for :users
  root to: "welcome#index"
end
