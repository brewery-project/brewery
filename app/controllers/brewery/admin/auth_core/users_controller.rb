module Brewery
  class Admin::AuthCore::UsersController < Admin::BaseController

    def index
      @users = AuthCore::User.paginate(page: params['page'])
      render :index

      authorize! :manage, AuthCore::User
    end
  end
end