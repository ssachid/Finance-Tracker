Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "user/registrations"}
  get 'welcome/index'
  root "welcome#index"

  get 'my_portfolio', to: "users#my_portfolio"
  get 'search_stocks', to: "stocks#search"
  get 'my_friends', to: "users#my_friends"

  resources :user_stocks, only: [:create, :destroy]
  resources :users, only: [:show]
  resources :friendships
end
