require_dependency "brewery/application_controller"

module Brewery
  class AuthCore::UsersController < ApplicationController
    def new
      authorize! :create, AuthCore::User

      @user = AuthCore::User.new
    end

    def create
      authorize! :create, AuthCore::User

      @user = AuthCore::User.new(user_params(true))

      if @user.save
        @user.has_role!(Brewery::AuthCore.default_new_user_role)
        next_url = nil
        class_names = Brewery::AuthCore.signup_flow_classes.dup
        while next_url.nil?
          class_name = class_names.pop
          klass = class_name.constantize
          next_url = klass.next_url(@user, self)
        end

        redirect_to next_url, success: I18n.t('create.success', scope: i18n_scope)
      else
        flash.now[:error] = I18n.t('create.failure', scope: i18n_scope)
        render :new
      end
    end

    def confirm
      @user = AuthCore::User.where(perishable_token: params[:key]).first

      if @user.nil?
        redirect_to main_app.root_path, error: I18n.t('confirm.failure', scope: i18n_scope)
      else
        @user.active = true
        @user.reset_perishable_token
        @user.save! # Failure on this should not happen.
        redirect_to main_app.root_path, success: I18n.t('confirm.success', scope: i18n_scope)
      end
    end

    def self.next_url(user, controller_for_url_helpers)
      if user.persisted?
        return controller_for_url_helpers.main_app.root_url
      else
        return nil
      end
    end

    private

    def user_params(is_new)
      base_allowed = [:family_name, :other_names, :password, :password_confirmation, :new_email]
      if is_new
        params.require(:auth_core_user).permit(:email, *base_allowed)
      else
        params.require(:auth_core_user).permit(*base_allowed)
      end
    end
  end
end
