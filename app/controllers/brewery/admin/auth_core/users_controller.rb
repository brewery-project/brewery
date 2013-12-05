require_dependency "brewery/application_controller"

module Brewery
  class Admin::AuthCore::UsersController < ApplicationController
    include Admin::BaseController
    load_and_protect

    class AdminModule
      def self.title
        return I18n.t('brewery.admin.auth_core.users.title')
      end

      def self.link(context)
          context.brewery.admin_auth_core_users_path
      end

      def self.can?(ability)
        return ability.can?(:manage, Brewery::AuthCore::User)
      end

      def self.glyphicon
        return 'user'
      end
    end
    before_filter :index_crumb, except: :index
    before_filter :show_crumb, except: [:index, :show]

    def index
      @users = @users.paginate(page: params['page'])
      add_crumb(I18n.t('brewery.admin.auth_core.users.title'), nil)

      render :index
    end

    def show
      add_crumb(@user.display_name)
    end

    def edit
      add_crumb(I18n.t('brewery.general.actions.edit'))
    end

    def update
      add_crumb(I18n.t('brewery.general.actions.edit'))
      if @user.update_attributes(user_params)
        redirect_to [:admin, @user], success: I18n.t('brewery.admin.auth_core.users.update.success')
      else
        flash.now[:error] = I18n.t('brewery.admin.auth_core.users.update.error')
        render :edit
      end
    end

    private

    def index_crumb
      add_crumb(I18n.t('brewery.admin.auth_core.users.title'), admin_auth_core_users_path)
    end

    def show_crumb
      add_crumb(@user.display_name, admin_auth_core_user_path(@user))
    end

    def user_params
      base_allowed = [:family_name, :other_names, :password, :password_confirmation, :new_email, assignable_role_ids: []]
      params.require(:admin_auth_core_user).permit(base_allowed)
    end
  end
end