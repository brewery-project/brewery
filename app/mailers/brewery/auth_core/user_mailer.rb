module Brewery
  class AuthCore::UserMailer < ActionMailer::Base
    default from: "from@example.com"

    def welcome_after_signup(user)
      @user = user

      mail(to: user.email,
           subject: I18n.t('user.mailer.welcome_after_signup.subject', app_name: I18n.t('global.app_name'))) do |format|
        format.html
      end
    end

    def request_new_password(user)
      @user = user

      mail(to: user.email,
           subject: I18n.t('user.mailer.reset_new_password.subject', app_name: I18n.t('global.app_name'))) do |format|
        format.html
      end
    end
  end
end
