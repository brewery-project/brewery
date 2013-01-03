Brewery::Engine.routes.draw do
  scope module: :auth_core, as: :auth_core do
    resource :users do
      get '/confirm/:key', action: :confirm, as: :confirm
    end
  end
end
