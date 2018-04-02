module Brewery
  class AuthCore::User < ActiveRecord::Base
    has_and_belongs_to_many :roles
    has_and_belongs_to_many :assignable_roles, Proc.new { where hidden: false }, class_name: 'Brewery::AuthCore::Role'

    acts_as_authentic do |config|
      config.logged_in_timeout = 1.hours
      config.disable_perishable_token_maintenance = true
      config.crypto_provider = Authlogic::CryptoProviders::Sha512
      config.validates_uniqueness_of_email_field_options(scope: :tenant_id)
      config.validate_password_field = false
    end

    before_create do
      reset_perishable_token
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
      return roles.where(name: name.to_s, authorizable_type: nil, authorizable_id: nil).exists?
    end

    def has_role!(name)
      if AuthCore::Role.where(name: name.to_s, authorizable_type: nil, authorizable_id: nil).exists?
        role = AuthCore::Role.where(name: name.to_s, authorizable_type: nil, authorizable_id: nil).first
      else
        role = AuthCore::Role.new(name: name.to_s)
      end

      roles << role
      save!
    end

    def has_no_role!(name)
      role = AuthCore::Role.where(name: name.to_s, authorizable_type: nil, authorizable_id: nil).first

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
