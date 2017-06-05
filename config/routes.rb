Rails.application.routes.draw do
  devise_for :users
  resources :posts
  root "posts#index"
  get "/about" => "pages#about"
  get "/toupiao" => "pages#toupiao"
  get "/xiangce" => "pages#xiangce"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
