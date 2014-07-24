module Brewery
  class AuthCore::UserSession < Authlogic::Session::Base
    logout_on_timeout true
    disable_magic_states true

    validate :is_user_blocked?

    private
    def is_user_blocked?
        if attempted_record && attempted_record.blocked?
            errors[:base] << I18n.t('active_record.errors.brewery/auth_core/user_session.blocked')
        end
    end
  end
end