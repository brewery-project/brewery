Rails.application.routes.draw do
  root to: 'application#index'

  mount Brewery::Engine => "/"

  get '/custom/signup', to: 'custom#signup'
end
