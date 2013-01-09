require 'test_helper'

module Brewery
  class AuthCore::SessionsControllerTest < ActionController::TestCase
    test "get login page" do
      get :new, use_route: :brewery

      assert_response :success

      assert_nil AuthCore::UserSession.find
      assert_not_nil assigns[:user_session]
    end

    test "do successful login" do
      assert_nil AuthCore::UserSession.find
      post :create, { brewery_auth_core_user_session: { email: 'already_used@example.org', password: 'user_1' }, use_route: :brewery }

      assert_response :redirect
      session = AuthCore::UserSession.find
      assert_not_nil session
      assert_equal brewery_auth_core_users(:user_1).email, session.user.email

      assert_not_nil flash[:success]
      assert_nil flash[:error]
    end

    test "do failed login" do
      assert_nil AuthCore::UserSession.find
      post :create, { brewery_auth_core_user_session: { email: 'already_used@example.org', password: 'failed_user_1' }, use_route: :brewery }

      assert_response :success
      assert_template :new
      assert_nil AuthCore::UserSession.find

      assert_not_nil flash[:error]
      assert_nil flash[:success]
    end

    test "do logout" do
      login_as(:user_1)

      assert_not_nil AuthCore::UserSession.find
      get :destroy, use_route: :brewery

      assert_response :redirect
      assert_nil AuthCore::UserSession.find
      assert_not_nil flash[:success]
      assert_nil flash[:error]
    end

    test "do logout as anonymous user" do
      get :destroy, use_route: :brewery

      assert_response :redirect
      assert_nil AuthCore::UserSession.find
      assert_not_nil flash[:success]
      assert_nil flash[:error]
    end
  end
end
