Rails.application.routes.draw do
  locale_regexp = /([a-z][a-z](-[A-Z][A-Z])?)/
  get '/:locale', to: 'application#index', as: :root, locale: locale_regexp

  mount Brewery::Engine => "/"

  get '/:locale/custom/signup', to: 'custom#signup', locale: locale_regexp, as: :custom_signup
end
