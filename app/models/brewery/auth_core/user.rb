module Brewery
  class AuthCore::User < ActiveRecord::Base
    acts_as_authentic

    after_create do
      AuthCore::UserMailer.welcome_after_signup(self).deliver
    end
  end
end
