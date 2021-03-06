Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :tournaments, only: [:index, :show, :new, :create] do
    resources :games, only: :create
  end
end
