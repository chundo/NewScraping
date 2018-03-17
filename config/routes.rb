Rails.application.routes.draw do  

  
  root 'home#index'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :categories
  resources :posts
  resources :tags

  get 'noticias' => 'home#noticias'
  get 'noticia/:id' => 'home#noticia', :as => 'noticia'
  get 'categoria/:id' => 'home#categoria', :as => 'categoria'
  get 'scraping' => 'home#scraping'
  post 'scraping' => 'home#scraping'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
