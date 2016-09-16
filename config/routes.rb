Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'pages#home'

  resources :bots do
    resources :histories, only: [:index]
    resources :patterns, except: [:show]
    resources :intents, except: [:show]
    resources :products
    resources :orders
    member do
      get 'analytic', to: 'bots#analytic'
      get 'webhook', to: "bots#webhook_verification"
      get 'webhook_subscribe', to: 'bots#webhook_subscribe'
      post 'webhook', to: 'bots#webhook'
      get 'guide', to: 'bots#guide'
      patch 'toggle/:id', to: 'bots#toggle', as: :toggle
      get 'delete_agenda_entry', to: 'bots#delete_agenda_entry'
      get 'add_agenda_entry', to: 'bots#add_agenda_entry'
    end
  end

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
end
