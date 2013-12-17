Brewery::Engine.routes.draw do
  locale_regexp = /([a-z][a-z](-[A-Z][A-Z])?)/
  scope ':locale', locale: locale_regexp do
    scope module: :auth_core, as: :auth_core do
      resource :users do
        get '/confirm/:key', action: :confirm, as: :confirm
      end

      get '/login', action: :new, controller: :sessions, as: :login
      post '/login', action: :create, controller: :sessions
      get '/logout', action: :destroy, controller: :sessions, as: :logout
    end

    namespace :admin do
      get '/', action: :index, controller: :dashboard
      get '/search', action: :search, controller: :dashboard, as: :search

      scope module: :auth_core, as: :auth_core do
        resources :users
      end
    end
  end
end
