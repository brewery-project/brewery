Brewery::Engine.routes.draw do
  scope module: :auth_core, as: :auth_core do
    resource :users do
      get '/confirm/:key', action: :confirm, as: :confirm
    end

    get '/login', action: :new, controller: :sessions, as: :login
    post '/login', action: :create, controller: :sessions
    get '/logout', action: :destroy, controller: :sessions, as: :logout
  end
end
