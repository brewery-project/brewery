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
      user = FactoryGirl.create(:user_superadmin)
      login_as(user)
      get :index, use_route: :brewery

      assert_response :success
      assert_nil flash[:error]
    end

    test "index is permitted as user with user admin rights" do
      user_admin = FactoryGirl.create(:user_admin)
      login_as(user_admin)
      get :index, use_route: :brewery

      assert_response :success
      assert_not_nil assigns[:users]
      assert_nil flash[:error]
    end

    test "index is denied as non admin user" do
      user = FactoryGirl.create(:user)
      login_as(user)
      get :index, use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:error]
    end

    ## Show
    test "show by authorized users" do
      user_admin = FactoryGirl.create(:user_admin)
      login_as(user_admin)
      get :show, id: user_admin.id, use_route: :brewery

      assert_response :success
      assert_not_nil assigns[:user]
    end

    test "show with invalid id by authorized user" do
      user_admin = FactoryGirl.create(:user_admin)
      login_as(user_admin)
      get :show, id: 0, use_route: :brewery

      assert_response 404
      assert_not_nil flash[:error]
      flash.sweep
      assert_nil flash[:error]
    end

    test "show as unauthorized user redirects" do
      user = FactoryGirl.create(:user)
      login_as(user)
      get :show, id: user.id, use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:error]
    end

    ## Edit

    test "edit by authorized users" do
      user = FactoryGirl.create(:user_admin)
      login_as(user)
      assert user.has_role?(:admin_user)
      get :edit, id: user.id, use_route: :brewery

      assert_response :success
      assert_not_nil assigns[:user]
    end

    test "edit with invalid id by authorized user" do
      user = FactoryGirl.create(:user_admin)
      login_as(user)
      get :edit, id: 0, use_route: :brewery

      assert_response 404
      assert_not_nil flash[:error]
      flash.sweep
      assert_nil flash[:error]
    end

    test "edit as unauthorized user redirects" do
      user = FactoryGirl.create(:user)
      login_as(user)
      get :edit, id: user.id, use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:error]
    end

    ## Update
    test "update by authorized users" do
      user = FactoryGirl.create(:user_admin)
      login_as(user)
      get :update, id: user.id,
                  admin_auth_core_user: { other_names: 'John Doe' },
                  use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:success]
      assert_nil flash[:error]
    end

    test "failed update by authorized users" do
      user = FactoryGirl.create(:user_admin)
      login_as(user)
      get :update, id: user.id,
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
      user = FactoryGirl.create(:user_admin)
      login_as(user)
      get :update, id: 0,
                  admin_auth_core_user: { other_names: 'John Doe' },
                  use_route: :brewery

      assert_response 404
      assert_not_nil flash[:error]
      flash.sweep
      assert_nil flash[:error]
    end

    test "update as unauthorized user redirects" do
      user = FactoryGirl.create(:user)
      login_as(user)
      get :update, id: user.id,
                  admin_auth_core_user: { other_names: 'John Doe' },
                  use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:error]
    end
  end
end