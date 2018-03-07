Rails.application.routes.draw do  

  resources :tags
  root 'home#index'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :categories
  resources :posts

  get 'noticias' => 'home#noticias'
  get 'scraping' => 'home#scraping'
  post 'scraping' => 'home#scraping'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
