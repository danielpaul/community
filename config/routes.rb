Rails.application.routes.default_url_options[:host] = "XXX"

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "welcome#index"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users, only: [:index, :show, :edit, :update, :destroy]
  get '/setup', to: 'users#setup', as: :setup

  resources :posts, only: [:index, :show, :new, :create, :edit, :update, :destroy]

end
