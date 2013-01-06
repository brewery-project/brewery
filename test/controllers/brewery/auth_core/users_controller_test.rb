require 'test_helper'

module Brewery
  class AuthCore::UsersControllerTest < ActionController::TestCase
    @@secret_keys = [:active, :crypted_password, :password_salt,
                     :persistence_token, :perishable_token, :single_access_token,
                     :login_count, :last_request_at, :last_login_at, :current_login_at,
                     :last_login_ip, :current_login_ip, :created_at, :updated_at]

    test "get new works" do
      get :new, { use_route: :brewery }

      assert_template 'new'
      assigns[:user].wont_be_nil
      assigns[:user].must_respond_to :email
    end

    test "post create creates user and redirects" do
      AuthCore::User.where(email: 'not_yet_used@example.org').first.must_be_nil

      post :create, { auth_core_user: { email: 'not_yet_used@example.org', password: 'password', password_confirmation: 'password' }, use_route: :brewery }

      #assert_redirected_to main_app.root_url
      assert_response :redirect
      flash[:notice].wont_be_nil
      flash[:error].must_be_nil

      user = AuthCore::User.where(email: 'not_yet_used@example.org').first
      user.wont_be_nil
      assert_not user.active?
      user.perishable_token.wont_be_nil
    end

    test "post create fails and shows form" do
      #fail "should test"
    end

    test "post create ignores all internal fields" do
      base_user = { email: 'not_yet_used@example.org', password: 'password', password_confirmation: 'password' }

      @@secret_keys.each do |key|
        user = base_user.clone
        user[key] = 'RaRaRaRandom4'

        assert_raise ActionController::UnpermittedParameters do
          post :create, { auth_core_user: user, use_route: :brewery }
        end
      end
    end

    test "get confirm activates user" do
      #fail "should test"
    end

    test "get confirm with invalid key does not activate anyone" do
      #fail "should test"
    end
  end
end
