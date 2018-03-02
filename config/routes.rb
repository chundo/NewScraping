Rails.application.routes.draw do
  root 'home#index'
  get 'noticias' => 'home#noticias'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
