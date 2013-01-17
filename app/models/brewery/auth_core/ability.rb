module Brewery
  class AuthCore::Ability
    include CanCan::Ability

    def initialize(user)
      anonymous and return if user.nil?

      if user.has_role? :superadmin
        can :access, :admin

        can :manage, AuthCore::User
      end

      if user.has_role? :admin
        can :access, :admin
      end

      if user.has_role? :admin_user
        can :manage, AuthCore::User
      end

      can :destroy, AuthCore::UserSession
    end

    private

    def anonymous
      can :manage, AuthCore::UserSession
      can :create, AuthCore::User
    end
  end
end