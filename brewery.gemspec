$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "brewery/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "brewery"
  s.version     = Brewery::VERSION
  s.authors     = ["Nathan Samson"]
  s.email       = ["brewery@nathansamson.be"]
  s.homepage    = "https://github.com/brewery-project/brewer"
  s.summary     = "Brewery Rails Engine."
  s.description = "Brewery is a Rails Engine to create (Brew) your own website either being a blog, ecommerce site, or anything you can imagine."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "> 4.2.4"
  #s.add_dependency "sass-rails", "~> 5.0"
  #s.add_dependency "jquery-rails", "~> 3.1.2"
  #s.add_dependency "coffee-rails", "~> 4.1"

  s.add_dependency 'authlogic', '~> 3.4'
  s.add_dependency 'bootstrap-sass', '~> 3.2'
  s.add_dependency 'cancancan', '~> 1.9'
  s.add_dependency 'will_paginate', '~> 3.0'
  #s.add_dependency 'foreigner'
  s.add_dependency 'crummy'
  s.add_dependency 'email_validator'
  s.add_dependency 'simple_form', '~> 3.0'

  s.add_development_dependency "minitest-rails"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rails_best_practices", '~> 1.15'
  s.add_development_dependency "coveralls"
  s.add_development_dependency "factory_girl_rails", "~> 4.5"
end
