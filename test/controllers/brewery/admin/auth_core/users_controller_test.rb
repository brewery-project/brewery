require 'test_helper'

module Brewery
  class Admin::AuthCore::UsersControllerTest < ActionController::TestCase
    ## Index

    test "index is denied as anonymous user" do
      get :index, use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:error]
    end

    test "index is permitted as superadmin user" do
      login_as(:user_1)
      get :index, use_route: :brewery

      assert_response :success
      assert_nil flash[:error]
    end

    test "index is permitted as user with user admin rights" do
      login_as(:user_with_admin_rights)
      get :index, use_route: :brewery

      assert_response :success
      assert_not_nil assigns[:users]
      assert_nil flash[:error]
    end

    test "index is denied as non admin user" do
      login_as(:user_2_with_full_names)
      get :index, use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:error]
    end

    ## Show
    test "show by authorized users" do
      login_as(:user_with_admin_rights)
      get :show, id: brewery_auth_core_users(:user_1).id, use_route: :brewery

      assert_response :success
      assert_not_nil assigns[:user]
    end

    test "show with invalid id by authorized user" do
      login_as(:user_with_admin_rights)
      get :show, id: 0, use_route: :brewery

      assert_response 404
      assert_not_nil flash[:error]
      flash.sweep
      assert_nil flash[:error]
    end

    test "show as unauthorized user redirects" do
      login_as(:user_2_with_full_names)
      get :show, id: brewery_auth_core_users(:user_1).id, use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:error]
    end

    ## Edit

    test "edit by authorized users" do
      login_as(:user_with_admin_rights)
      get :edit, id: brewery_auth_core_users(:user_1).id, use_route: :brewery

      assert_response :success
      assert_not_nil assigns[:user]
    end

    test "edit with invalid id by authorized user" do
      login_as(:user_with_admin_rights)
      get :edit, id: 0, use_route: :brewery

      assert_response 404
      assert_not_nil flash[:error]
      flash.sweep
      assert_nil flash[:error]
    end

    test "edit as unauthorized user redirects" do
      login_as(:user_2_with_full_names)
      get :edit, id: brewery_auth_core_users(:user_1).id, use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:error]
    end

    ## Update
    test "update by authorized users" do
      login_as(:user_with_admin_rights)
      get :update, id: brewery_auth_core_users(:user_1).id,
                  admin_auth_core_user: { other_names: 'John Doe' },
                  use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:success]
      assert_nil flash[:error]
    end

    test "failed update by authorized users" do
      login_as(:user_with_admin_rights)
      get :update, id: brewery_auth_core_users(:user_1).id,
                  admin_auth_core_user: { new_email: 'not a valid email' },
                  use_route: :brewery

      assert_response :success
      assert_not_nil assigns[:user]
      assert_not_nil flash[:error]
      assert_nil flash[:success]

      flash.sweep
      assert_nil flash[:error]
      assert_nil flash[:success]
    end

    test "update with invalid id by authorized user" do
      login_as(:user_with_admin_rights)
      get :update, id: 0,
                  admin_auth_core_user: { other_names: 'John Doe' },
                  use_route: :brewery

      assert_response 404
      assert_not_nil flash[:error]
      flash.sweep
      assert_nil flash[:error]
    end

    test "update as unauthorized user redirects" do
      login_as(:user_2_with_full_names)
      get :update, id: brewery_auth_core_users(:user_1).id,
                  admin_auth_core_user: { other_names: 'John Doe' },
                  use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:error]
    end

    private
    def give(user, role)
      user = brewery_auth_core_users(user)
      user.has_role! :admin_user
    end
  end
end