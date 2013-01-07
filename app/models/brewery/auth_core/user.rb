module Brewery
  class AuthCore::User < ActiveRecord::Base
    acts_as_authentic do |config|
      config.logged_in_timeout = 1.hours
    end

    after_create do
      AuthCore::UserMailer.welcome_after_signup(self).deliver
    end
  end
end
