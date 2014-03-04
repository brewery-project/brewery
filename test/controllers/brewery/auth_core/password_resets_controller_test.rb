require 'test_helper'

module Brewery
    class AuthCore::PasswordResetsControllerTest < ActionController::TestCase
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
                           brewery_auth_core_users: { password: 'testtest', password_confirmation: 'testtest' }

            user.reload
            assert_equal old_pw, user.password_salt

            assert_redirected_to root_path(locale: 'en')
        end

        test "modify password action with wrong pt" do
            user = FactoryGirl.create(:user)

            old_pw = user.password_salt
            patch :update, id: user.id, key: user.perishable_token * 2, use_route: :brewery,
                           brewery_auth_core_users: { password: 'testtest', password_confirmation: 'testtest' }

            user.reload
            assert_equal old_pw, user.password_salt

            assert_redirected_to root_path(locale: 'en')
        end
    end
end
