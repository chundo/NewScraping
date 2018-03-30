Rails.application.routes.draw do  

  
  resources :covers
  root 'home#index'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :categories
  #resources :posts
  resources :tags

  get 'videos' => 'home#noticias'
  get 'video/:id' => 'posts#show', :as => 'video'
  get 'categoria/:id' => 'home#categoria', :as => 'categoria'
  get 'videos/:id' => 'home#videos', :as => 'videos_i'
  get 'buscar' => 'home#buscar'
  post 'buscar' => 'home#buscar'
  
  get 'scraping' => 'home#scraping'
  post 'scraping' => 'home#scraping'
  get 'test' => 'home#test'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

