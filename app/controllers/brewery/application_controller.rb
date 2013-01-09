module Brewery
  class ApplicationController < ActionController::Base
    add_flash_types :error, :success, :info

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = AuthCore::UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    helper_method :current_user

    def current_ability
      @current_ability ||= AuthCore::Ability.new(current_user)
    end

    protected
    def base_i18n_scope
      self.class.name.sub(/Controller$/, '').underscore.split('/').map do |name|
        name.to_sym
      end
    end

    def i18n_scope
      @i18n_scope ||= base_i18n_scope
    end
  end
end
