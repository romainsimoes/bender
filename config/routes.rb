Rails.application.routes.draw do
  root to: 'pages#home'

  resources :bots do
    resources :histories, only: [:index]
    resources :patterns, except: [:show]
    get 'analytic', to: 'bots#analytic'
    post 'webhook', to: 'bots#webhook'
    get 'guide', to: 'bots#guide'
  end

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
