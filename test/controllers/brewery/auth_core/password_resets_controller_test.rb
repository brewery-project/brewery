require 'test_helper'

module Brewery
    class AuthCore::PasswordResetsControllerTest < ActionController::TestCase
        test "request a new password screen" do
            user = FactoryGirl.create(:user)

            get :new, use_route: :brewery

            assert_response :success
            assert_template :new
        end

        test "request a new password" do
            user = FactoryGirl.create(:user)

            p_token  = user.perishable_token
            assert_difference 'ActionMailer::Base.deliveries.count' do
                get :create, email: user.email, use_route: :brewery
            end

            user.reload
            assert_not_equal p_token, user.perishable_token

            assert_response :redirect
            assert_redirected_to root_path(locale: 'en')
            assert_not_nil flash[:success]
        end

        test "request a new password with invalid email" do
            user = FactoryGirl.create(:user)

            p_token  = user.perishable_token
            assert_difference 'ActionMailer::Base.deliveries.count', 0 do
                get :create, email: user.email * 2, use_route: :brewery
            end

            user.reload
            assert_equal p_token, user.perishable_token

            assert_response :redirect
            assert_redirected_to root_path(locale: 'en')
            assert_not_nil flash[:success]
        end

        test "modify password screen" do
            user = FactoryGirl.create(:user)

            get :edit, id: user.id, key: user.perishable_token, use_route: :brewery

            assert_template :edit
        end

        test "modify password screen with wrong pt" do
            user = FactoryGirl.create(:user)

            get :edit, id: user.id, key: user.perishable_token * 2, use_route: :brewery

            assert_redirected_to root_path(locale: 'en')
        end

        test "modify password action" do
            user = FactoryGirl.create(:user)

            old_pw = user.password_salt

            patch :update, id: user.id, key: user.perishable_token, use_route: :brewery,
                           auth_core_user: { password: 'testtest', password_confirmation: 'testtest' }

            user.reload
            assert_not_equal old_pw, user.password_salt

            assert_redirected_to root_path(locale: 'en')
        end

        test "modify password action with wrong password" do
            user = FactoryGirl.create(:user)

            old_pw = user.password_salt

            patch :update, id: user.id, key: user.perishable_token, use_route: :brewery,
                           auth_core_user: { password: 'testtest', password_confirmation: 'testwrong' }

            user.reload
            assert_equal old_pw, user.password_salt

            assert_template :edit
        end

        test "modify password action with wrong pt" do
            user = FactoryGirl.create(:user)

            old_pw = user.password_salt
            patch :update, id: user.id, key: user.perishable_token * 2, use_route: :brewery,
                           auth_core_user: { password: 'testtest', password_confirmation: 'testtest' }

            user.reload
            assert_equal old_pw, user.password_salt

            assert_redirected_to root_path(locale: 'en')
        end
    end
end
