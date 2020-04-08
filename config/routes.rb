Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      get '/cases', to: 'cases#cases'

      namespace :cases do
        get '/earth', to: 'earth#index'
        get '/countries', to: 'countries#index'
        get '/states', to: 'states#index'
      end
    end
  end

  root 'page#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
