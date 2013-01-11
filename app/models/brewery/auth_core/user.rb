module Brewery
  class AuthCore::User < ActiveRecord::Base
    has_and_belongs_to_many :roles

    acts_as_authentic do |config|
      config.logged_in_timeout = 1.hours
    end

    after_create do
      AuthCore::UserMailer.welcome_after_signup(self).deliver
    end

    def display_name
      if !other_names.blank?
        return other_names
      elsif !family_name.blank?
        return family_name
      else
        return email
      end
    end
  end
end
