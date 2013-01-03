require 'test_helper'

module Brewery
  class AuthCore::UserTest < ActiveSupport::TestCase
    it "validates whenever it is valid" do
      user = valid_base_user_with_all_data
      user.save

      user.persisted?.must_be_same_as true
      user.active?.must_be_same_as false

      [:email, :other_names, :family_name, :password, :password_confirmation].each do |k|
        user.errors.messages[k].must_be_nil
      end
    end

    it "does not allow creation when email is not unique" do
      user = valid_base_user_with_all_data
      user.email = 'already_used@example.org'

      user.save
      user.persisted?.must_be_same_as false

      user.errors.messages[:email].wont_be_nil
      user.errors.messages[:email].count.must_be_same_as 1
    end

    it "does not allow creation when passwords do not match" do
      user = valid_base_user_with_all_data
      user.password_confirmation = 'not_my_password'

      user.save
      user.persisted?.must_be_same_as false

      user.errors.messages[:password_confirmation].wont_be_nil
    end

    it "does not allow creation when email doesnt look like an email" do
      user = valid_base_user_with_all_data
      user.email = 'not_used'

      user.save
      user.persisted?.must_be_same_as false

      user.errors.messages[:email].wont_be_nil
    end

    it "does allow empty names" do
      user = valid_base_user_with_all_data
      user.family_name = nil
      user.other_names = nil
      user.save

      user.persisted?.must_be_same_as true
      user.active?.must_be_same_as false

      [:email, :other_names, :family_name, :password, :password_confirmation].each do |k|
        user.errors.messages[k].must_be_nil
      end
    end

    private
    def valid_base_user_with_all_data
      valid_user = AuthCore::User.new
      valid_user.email = "not_already_used@example.org"
      valid_user.password = 'my_password'
      valid_user.password_confirmation = 'my_password'
      valid_user.family_name = 'User'
      valid_user.other_names = 'Newly Created'

      return valid_user
    end
  end
end
