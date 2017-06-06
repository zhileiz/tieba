Rails.application.routes.draw do
  devise_for :users
  resources :posts
  root "posts#index"
  get "/about" => "pages#about"
  get "/toupiao" => "pages#toupiao"
  get "/xiangce" => "pages#xiangce"
  get 'users/:id' => 'users#show', :as => 'usershow'
  get 'users' => 'users#index', :as => 'userindex'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
