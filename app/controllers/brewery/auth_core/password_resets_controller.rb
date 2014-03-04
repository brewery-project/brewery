require_dependency "brewery/application_controller"

module Brewery
    class AuthCore::PasswordResetsController < ApplicationController
        before_action :find_user, only: [:edit, :update]

        def create
            @user = AuthCore::User.find_by_email(params[:email])

            @user.reset_perishable_token!
            AuthCore::UserMailer.request_new_password(@user).deliver

            redirect_to main_app.root_path
        end

        def edit
        end

        def update
            redirect_to main_app.root_path
        end

        private
        def find_user
            @user = AuthCore::User.find(params[:id])

            if @user.perishable_token != params[:key]
                redirect_to main_app.root_path
            end

            return true
        end
    end
end