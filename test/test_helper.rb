# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'coveralls'
Coveralls.wear!('rails')

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

require "minitest/spec"
require "authlogic/test_case"

require 'factory_girl_rails'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)

class ActionController::TestCase < ActiveSupport::TestCase
  include Authlogic::TestCase
  include Brewery::Engine.routes.url_helpers
  include Rails.application.routes.url_helpers

  setup :activate_authlogic

  def login_as(user)
    Brewery::AuthCore::UserSession.create(user)
  end
end
