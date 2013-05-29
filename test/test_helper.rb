# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

require "minitest/spec"
require "authlogic/test_case"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)

class ActiveSupport::TestCase
  fixtures :all
end

class ActionController::TestCase < ActiveSupport::TestCase
  include Authlogic::TestCase

  setup :activate_authlogic

  def login_as(key_or_email)
    if key_or_email.is_a?(Symbol)
      Brewery::AuthCore::UserSession.create(brewery_auth_core_users(key_or_email))
    else
      Brewery::AuthCore::UserSession.create(AuthCore::Users.where(email: key_or_email).first)
    end
  end
end
