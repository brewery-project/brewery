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
      attributes = FactoryGirl.attributes_for(:user)
      post :create, { auth_core_user: attributes, use_route: :brewery }

      #assert_redirected_to main_app.root_url
      assert_response :redirect
      flash[:success].wont_be_nil
      flash[:error].must_be_nil

      user = AuthCore::User.where(email: attributes[:email]).first
      user.wont_be_nil
      assert_not user.active?
      user.perishable_token.wont_be_nil
    end

    test "post create fails and shows form" do
      attributes = FactoryGirl.attributes_for(:user, password_confirmation: 'not the same password')
      post :create, { auth_core_user: attributes, use_route: :brewery }

      assert_response :success
      assert_template 'new'
      flash[:success].must_be_nil
      flash[:error].wont_be_nil
      flash.sweep
      flash[:success].must_be_nil
      flash[:error].must_be_nil

      user = AuthCore::User.where(email: attributes[:email]).first
      user.must_be_nil

      user = assigns[:user]
      user.wont_be_nil
      assert_equal attributes[:email], user.email
    end

    test "post create ignores all internal fields" do
      @@secret_keys.each do |key|
        attributes = FactoryGirl.attributes_for(:user)
        attributes[key] = 'RaRaRaRandom4'

        assert_equal 0, AuthCore::User.where(email: attributes[:email]).count

        #assert_raise ActionController::UnpermittedParameters do
          post :create, { auth_core_user: attributes, use_route: :brewery }
        #end

        assert_equal 1, AuthCore::User.where(email: attributes[:email]).count
        user = AuthCore::User.where(email: attributes[:email]).first
        assert_not_equal attributes[key], user.send(key)
      end
    end

    test "get confirm activates user" do
      user = FactoryGirl.create(:user)
      pt = user.perishable_token

      assert_difference 'AuthCore::User.where(active: true).count', 1 do
        get :confirm, { key: user.perishable_token, use_route: :brewery }
      end

      assert_response :redirect
      flash[:success].wont_be_nil
      flash[:error].must_be_nil

      active_user = AuthCore::User.where(email: user.email).first
      assert active_user.active?
      assert_not_equal pt, active_user.perishable_token
    end

    test "get confirm with invalid key does not activate anyone" do
      user = FactoryGirl.create(:user)

      assert_no_difference 'AuthCore::User.where(active: true).count' do
        get :confirm, { key: 'z', use_route: :brewery }
      end

      assert_response :redirect
      flash[:success].must_be_nil
      flash[:error].wont_be_nil

      active_user = AuthCore::User.where(email: user.email).first
      assert_not active_user.active?
    end

    test "redirect to custom step" do
      current_default_was = Brewery::AuthCore.default_new_user_role
      Brewery::AuthCore.default_new_user_role = :custom_role
      Brewery::AuthCore.signup_flow_classes.push('Brewery::AuthCore::UsersControllerTest::MockCustomStep')
      user_attributes = FactoryGirl.attributes_for(:user)

      post :create, { auth_core_user: user_attributes, use_route: :brewery }

      assert_redirected_to(custom_signup_path(locale: 'en'))
      assert_response :redirect
      flash[:success].wont_be_nil
      flash[:error].must_be_nil

      user = AuthCore::User.where(email: user_attributes[:email]).first
      user.has_role?(:custom_role)
      user.wont_be_nil
      assert_not user.active?
      user.perishable_token.wont_be_nil

      Brewery::AuthCore.default_new_user_role = current_default_was
      Brewery::AuthCore.signup_flow_classes.pop
    end

    class MockCustomStep
      def self.next_url(user, controller_for_url_helpers)
        if user.has_role?(:custom_role)
          return controller_for_url_helpers.main_app.custom_signup_path
        else
          return nil
        end
      end
    end

    test "it can edit" do
      user = FactoryGirl.create(:user)
      login_as(user)

      get :edit, use_route: :brewery

      assert_template :edit
      assert_not_nil assigns[:user]
    end

    test "it can not edit as anon user" do
      get :edit, use_route: :brewery

      assert_redirected_to Brewery::Engine.routes.url_helpers.auth_core_login_path(locale: 'en')
    end

    test "it can update" do
      user = FactoryGirl.create(:user)
      login_as(user)

      patch :update, auth_core_user: { other_names: 'Change', family_name: 'This' }, use_route: :brewery

      assert_redirected_to Brewery::Engine.routes.url_helpers.edit_auth_core_users_path(locale: 'en')

      user.reload
      assert_equal 'Change', user.other_names
      assert_equal 'This', user.family_name
      assert_nil flash[:error]
      assert_not_nil flash[:success]
    end

    test "it can fail to update" do
      user = FactoryGirl.create(:user)
      login_as(user)

      patch :update, auth_core_user: { password: 'Changed', password_confirmation: 'Changed But Not The ams' }, use_route: :brewery

      assert_template :edit
      assert_not_nil assigns[:user]
      assert_not_nil flash[:error]
    end
  end
end
