require_dependency "brewery/application_controller"

module Brewery
  class AuthCore::SessionsController < ApplicationController
    def new
      @user_session = AuthCore::UserSession.new
    end

    def create
      @user_session = AuthCore::UserSession.new(user_session_params)
      if @user_session.save
        redirect_to main_app.root_url, success: I18n.t('create.success', scope: i18n_scope)
      else
        flash[:error] = I18n.t('create.failure', scope: i18n_scope)
        render :new
      end
    end

    def destroy
      session = AuthCore::UserSession.find
      session.destroy if session

      redirect_to main_app.root_url, success: I18n.t('destroy.success', scope: i18n_scope)
    end

    private
    def user_session_params
      params.require(:brewery_auth_core_user_session).permit(:email, :password)
    end
  end
end
