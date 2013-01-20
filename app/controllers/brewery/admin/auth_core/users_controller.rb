module Brewery
  class Admin::AuthCore::UsersController < Admin::BaseController
    load_and_protect

    def index
      @users = @users.paginate(page: params['page'])

      render :index
    end

    def show
    end

    def edit
    end

    def update
      if @user.update_attributes(user_params)
        redirect_to [:admin, @user], success: I18n.t('brewery.admin.auth_core.users.update.success')
      else
        flash.now[:error] = I18n.t('brewery.admin.auth_core.users.update.error')
        render :edit
      end
    end

    private
    def user_params
      base_allowed = [:family_name, :other_names, :password, :password_confirmation, :new_email]
      params.require(:admin_auth_core_user).permit(base_allowed)
    end
  end
end