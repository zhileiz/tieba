Rails.application.routes.draw do
  devise_for :users
  resources :posts do
    resources :replies
    member do
      put "like", to: "posts#upvote"
      put "jing", to: "posts#makejing"
      put "stick", to: "posts#makesticky"
    end
  end
  root "posts#index"
  get "/about" => "pages#about"
  get "/toupiao" => "pages#toupiao"
  get "/xiangce" => "pages#xiangce"
  get 'users/:id' => 'users#show', :as => 'usershow'
  get 'users' => 'users#index', :as => 'userindex'
  get '/by-post' => 'posts#indexbypost', :as => 'indexbypost'
  get '/by-reply' => 'posts#indexbyreply', :as => 'indexbyreply'
  get '/by-trend' => 'posts#indexbypop', :as => 'indexbypop'
  get '/top' => 'posts#jingping', :as => 'jingping'
end
