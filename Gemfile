source "https://rubygems.org"

# Declare your gem's dependencies in brewery.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# Your gem is dependent on dev or edge Rails. Once you can lock this
# dependency down to a specific version, move it to your gemspec.
gem 'rails',     github: 'rails/rails'
gem 'arel',      github: 'rails/arel'

group :assets do
  gem 'sprockets-rails', github: 'rails/sprockets-rails'
  gem 'sass-rails',   github: 'rails/sass-rails'
  gem 'coffee-rails', github: 'rails/coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails',     github: 'rails/jquery-rails'
gem 'turbolinks'#,     github: 'rails/turbolinks', branch: ''

# To use debugger
# gem 'debugger'

gem 'simple_form', github: 'plataformatec/simple_form', branch: 'rails_4'