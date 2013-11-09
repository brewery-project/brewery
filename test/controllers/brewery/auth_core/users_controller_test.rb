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

      assert_difference 'AuthCore::User.where(active: true).count', 1 do
        get :confirm, { key: user.perishable_token, use_route: :brewery }
      end

      assert_response :redirect
      flash[:success].wont_be_nil
      flash[:error].must_be_nil

      active_user = AuthCore::User.where(email: user.email).first
      assert active_user.active?
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
  end
end
