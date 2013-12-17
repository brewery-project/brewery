require 'test_helper'

module Brewery
  class Admin::DashboardControllerTest < ActionController::TestCase
    class ExtraModule
      def self.title
          return I18n.t('brewery.admin.dashboard.go_to_site')
      end

      def self.link(context)
          context.main_app.root_path
      end

      def self.can?(ability)
          return ability.object.has_role?(:some_strange_module)
      end

      def self.glyphicon
          return 'home'
      end
    end

    test "index is denied as anonymous user" do
      get :index, use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:error]
    end

    test "index is permitted as admin user" do
      user = FactoryGirl.create(:user_admin)
      login_as(user)
      get :index, use_route: :brewery

      assert_response :success
      assert_nil flash[:error]
      assert_select 'a[href="/en/admin/users"]', 1
      assert_select 'a[href="/en"]', 3
    end

    test "test index display extra modules if available" do
      user = FactoryGirl.create(:user_admin)
      user.has_role!(:some_strange_module)
      login_as(user)
      get :index, use_route: :brewery

      assert_response :success
      assert_nil flash[:error]
      assert_select 'a[href="/en/admin/users"]', 1
      assert_select 'a[href="/en"]', 4
    end

    test "test index does not display extra modules if not available" do
      # Not available for this user
      user = FactoryGirl.create(:user_admin)
      login_as(user)
      get :index, use_route: :brewery

      assert_response :success
      assert_nil flash[:error]
      assert_select 'a[href="/en/admin/users"]', 1
      assert_select 'a[href="/en"]', 3
    end

    test "index is denied as non admin user" do
      user = FactoryGirl.create(:user)
      login_as(user)
      get :index, use_route: :brewery

      assert_response :redirect
      assert_not_nil flash[:error]
    end
  end
end

Brewery::Admin::DashboardController.register_module(Brewery::Admin::DashboardControllerTest::ExtraModule, 4)