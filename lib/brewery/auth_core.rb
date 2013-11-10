module Brewery
  module AuthCore
    mattr_accessor :send_welcome_mail_after_signup
    mattr_accessor :default_new_user_role
    mattr_accessor :signup_flow_classes

    self.send_welcome_mail_after_signup = true
    self.default_new_user_role = :user_role
    self.signup_flow_classes = ['Brewery::AuthCore::UsersController']

    def self.table_name_prefix
      'brewery_auth_core_'
    end
  end
end
