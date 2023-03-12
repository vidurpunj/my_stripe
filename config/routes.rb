Rails.application.routes.draw do
  get 'welcome/index'
  resources :books do
    get 'new_purchase', to: 'books#new_purchase'
    post 'create_checkout_session', to: 'books#create_checkout_session'
    get 'success', to: 'books#success'
    get 'cancel', to: 'books#cancle'
  end
  resources :authors
  devise_for :users
  root to: "welcome#index"
end
