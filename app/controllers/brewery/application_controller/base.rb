module Brewery
    module ApplicationController::Base
        extend ActiveSupport::Concern

        included do
            add_flash_types :error, :success, :info
            rescue_from CanCan::AccessDenied, with: :on_access_denied

            around_filter :user_time_zone, :if => :current_user

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

            private
            def on_access_denied
                if current_user.nil?
                  redirect_to brewery.auth_core_login_path, error: I18n.t('brewery.auth_core.sessions.permission_denied_anonymous')
                else
                  redirect_to main_app.root_path, error: I18n.t('brewery.auth_core.sessions.permission_denied')
                end
            end

            def user_time_zone(&block)
                Time.use_zone('Europe/Brussels', &block)
            end
        end
    end
end