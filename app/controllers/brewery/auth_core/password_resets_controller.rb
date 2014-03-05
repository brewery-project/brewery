require_dependency "brewery/application_controller"

module Brewery
    class AuthCore::PasswordResetsController < ApplicationController
        before_action :find_user, only: [:edit, :update]

        def new
        end

        def create
            @user = AuthCore::User.find_by_email(params[:email])
            if !@user.nil?
                @user.reset_perishable_token!
                AuthCore::UserMailer.request_new_password(@user).deliver
            end

            redirect_to main_app.root_path
        end

        def edit
        end

        def update

            if @user.update_attributes(password_attributes)
                redirect_to main_app.root_path
            else
                render :edit
            end
        end

        private
        def find_user
            @user = AuthCore::User.find(params[:id])

            if @user.perishable_token != params[:key]
                redirect_to main_app.root_path
            end

            return true
        end

        def password_attributes
            params.require(:auth_core_user).permit(:password, :password_confirmation)
        end
    end
end
