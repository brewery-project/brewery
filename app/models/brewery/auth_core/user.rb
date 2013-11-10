module Brewery
  class AuthCore::User < ActiveRecord::Base
    has_and_belongs_to_many :roles
    has_and_belongs_to_many :assignable_roles, Proc.new { where hidden: false }, class_name: 'Brewery::AuthCore::Role'

    acts_as_authentic do |config|
      config.logged_in_timeout = 1.hours
    end

    after_create do
      if Brewery::AuthCore.send_welcome_mail_after_signup
        AuthCore::UserMailer.welcome_after_signup(self).deliver
      end
    end

    validates :new_email, email: true, allow_blank: true

    def display_name
      if !other_names.blank?
        return other_names
      elsif !family_name.blank?
        return family_name
      else
        return email
      end
    end

    def has_role?(name)
      return roles.where(name: name, authorizable_type: nil, authorizable_id: nil).exists?
    end

    def has_role!(name)
      if AuthCore::Role.where(name: name, authorizable_type: nil, authorizable_id: nil).exists?
        role = AuthCore::Role.where(name: name, authorizable_type: nil, authorizable_id: nil).first
      else
        role = AuthCore::Role.new(name: name)
      end

      roles << role
      save!
    end

    def has_no_role!(name)
      role = AuthCore::Role.where(name: name, authorizable_type: nil, authorizable_id: nil).first

      return false if role.nil?

      roles.destroy(role)
      if role.hidden && !role.users.any?
        role.destroy
      end
    end

    def unconfirmed_new_email?
      return !new_email.blank?
    end
  end
end
