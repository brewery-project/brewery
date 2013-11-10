module Brewery
  module AuthCore
    mattr_accessor :send_welcome_mail_after_signup
    mattr_accessor :default_new_user_role

    self.send_welcome_mail_after_signup = true
    self.default_new_user_role = :user_role

    def self.table_name_prefix
      'brewery_auth_core_'
    end
  end
end
