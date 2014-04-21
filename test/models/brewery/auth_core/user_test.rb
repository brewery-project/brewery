require 'test_helper'

module Brewery
  class AuthCore::UserTest < ActiveSupport::TestCase
    test "validates whenever it is valid" do
      user = FactoryGirl.create(:user)

      user.persisted?.must_be_same_as true
      user.active?.must_be_same_as false

      [:email, :other_names, :family_name, :password, :password_confirmation].each do |k|
        user.errors.messages[k].must_be_nil
      end
    end

    test "does not allow creation when email is not unique" do
      user1 = FactoryGirl.create(:user)

      user = FactoryGirl.build(:user, email: user1.email)
      user.save

      user.persisted?.must_be_same_as false

      user.errors.messages[:email].wont_be_nil
      user.errors.messages[:email].count.must_be_same_as 1
    end

    test "does not allow creation when passwords do not match" do
      user = FactoryGirl.build(:user, password: 'azerty', password_confirmation: 'qwerty')
      user.save

      user.persisted?.must_be_same_as false

      user.errors.messages[:password_confirmation].wont_be_nil
    end

    test "does not allow creation when email doesnt look like an email" do
      user = FactoryGirl.build(:user, email: 'ceci ne pas une email')

      user.save
      user.persisted?.must_be_same_as false

      user.errors.messages[:email].wont_be_nil
    end

    test "does allow empty names" do
      user = FactoryGirl.build(:user)
      user.family_name = nil
      user.other_names = nil
      user.save

      user.persisted?.must_be_same_as true
      user.active?.must_be_same_as false

      [:email, :other_names, :family_name, :password, :password_confirmation].each do |k|
        user.errors.messages[k].must_be_nil
      end
    end

    test "does not allow invalid new_email" do
      user = FactoryGirl.create(:user)
      user.new_email = 'not a valid email'

      assert_not user.valid?
      assert_not_nil user.errors.messages[:new_email]
    end

    test "allow blank new_email" do
      user = FactoryGirl.create(:user)
      user.new_email = ''

      assert user.valid?
      assert_nil user.errors.messages[:new_email]
    end

    test "unconfirmed_new_email?" do
      user = FactoryGirl.create(:user)

      assert_not user.unconfirmed_new_email?

      user.new_email = 'some_new_email@example.org'
      assert user.unconfirmed_new_email?
    end

    test "display_name returns email if name not set" do
      user = FactoryGirl.build(:user)

      assert_equal user.email, user.display_name
    end

    test "display_name returns other_names if names all set" do
      user = FactoryGirl.build(:user_with_names)

      assert_equal user.other_names, user.display_name
    end

    test "display_name returns family_name if only set" do
      user = FactoryGirl.build(:user_with_names, other_names: nil)

      assert_equal user.family_name, user.display_name
    end

    test "test has_role? returns correct value" do
      user = FactoryGirl.create(:user)
      assert_not user.has_role?(:imaginery_role)

      super_admin = FactoryGirl.create(:user_superadmin)
      assert super_admin.has_role?(:superadmin)

      assert_not user.has_role?(:superadmin)
    end

    test "test has_role! assigns new role" do
      user = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)

      assert_not user.has_role?(:new_role)
      user.has_role! :new_role
      assert user.has_role?(:new_role)

      user = AuthCore::User.find user.id
      assert user.has_role?(:new_role)

      assert_not user2.has_role?(:new_role)
    end

    test "test has_role! assigns existing role" do
      user = FactoryGirl.create(:user)
      assert_not user.has_role?(:superadmin)

      user.has_role! :superadmin
      assert user.has_role?(:superadmin)

      user = AuthCore::User.find user.id
      assert user.has_role?(:superadmin)
    end

    test "test has_no_role! revokes role" do
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      assert user1.has_role?(:user_role)
      assert user2.has_role?(:user_role)

      user2.has_no_role!(:user_role)
      assert user1.has_role?(:user_role)
      assert_not user2.has_role?(:user_role)
    end

    test "test has_no_role! cleans up after itself" do
      user1 = FactoryGirl.create(:user)
      user1.has_role!(:role_with_only_user1)
      user2 = FactoryGirl.create(:user)
      assert user1.has_role?(:role_with_only_user1)
      assert_not user2.has_role?(:role_with_only_user1)

      user1.has_no_role!(:role_with_only_user1)
      assert_not user1.has_role?(:role_with_only_user1)
      assert_not user2.has_role?(:role_with_only_user1)

      assert_not AuthCore::Role.where(name: :role_with_only_user1, authorizable_id: nil, authorizable_type: nil).exists?
    end

    test "test has_no_role! cleans up after itself unless not hidden role" do
      FactoryGirl.create(:superadmin_role)
      user1 = FactoryGirl.create(:user_superadmin)
      user2 = FactoryGirl.create(:user)
      assert user1.has_role?(:superadmin)
      assert_not user2.has_role?(:superadmin)

      user1.has_no_role!(:superadmin)
      assert_not user1.has_role?(:superadmin)
      assert_not user2.has_role?(:superadmin)

      assert AuthCore::Role.where(name: :superadmin, authorizable_id: nil, authorizable_type: nil).exists?
    end

    test "do send welcome email by default" do
      user = Brewery::AuthCore::User.new(FactoryGirl.attributes_for(:user))
      assert_difference 'ActionMailer::Base.deliveries.count', 1 do
        user.save!
      end

      mail = ActionMailer::Base.deliveries.last
      assert_equal user.email, mail.to.first
      assert_equal 1, mail.to.count
    end

    test "do not send welcome email if disabled" do
      config_value_was = Brewery::AuthCore.send_welcome_mail_after_signup
      Brewery::AuthCore.send_welcome_mail_after_signup = false

      user = Brewery::AuthCore::User.new(FactoryGirl.attributes_for(:user))
      assert_difference 'ActionMailer::Base.deliveries.count', 0 do
        user.save!
      end

      Brewery::AuthCore.send_welcome_mail_after_signup = config_value_was
    end

    test "perishable token does not change every time user is saved" do
      user = FactoryGirl.create(:user)
      pt1 = user.perishable_token

      user.other_names = 'Test'
      user.save!

      assert_equal pt1, user.perishable_token
    end

    class Ability
      def initialize(user, master, extra_parameters = {})
        return if user.nil?
        master.can :love, Brewery::AuthCore::User
      end
    end

    test "ability allows extra classes" do
      AuthCore::Ability.add_extra_ability_class_name('Brewery::AuthCore::UserTest::Ability')

      user = FactoryGirl.build(:user)
      ability = Brewery::AuthCore::Ability.new(user, {})

      assert ability.can?(:love, Brewery::AuthCore::User)
      assert_not ability.can?(:love2, Brewery::AuthCore::User)
    end
  end
end
