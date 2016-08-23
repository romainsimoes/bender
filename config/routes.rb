Rails.application.routes.draw do
  root to: 'pages#home'

  resources :bots do
    resources :histories, only: [:index]
    resources :patterns, except: [:show]
    member do
      get 'analytic', to: 'bots#analytic'
      get 'webhook', to: "bots#webhook_verification"
      post 'webhook', to: 'bots#webhook'
      get 'guide', to: 'bots#guide'
    end
  end

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
end
