module Brewery
    class AuthCore::Ability
      include CanCan::Ability

      def initialize(user)
        anonymous and return if user.nil?

        #if user.has_role? :superadmin
        #    can :manage, :all
        #end

        can :destroy, AuthCore::UserSession
      end

      private

      def anonymous
        can :manage, AuthCore::UserSession
        can :create, AuthCore::User
      end
    end
end