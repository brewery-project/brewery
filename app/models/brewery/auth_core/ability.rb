module Brewery
  class AuthCore::Ability
    @@extra_classes = []
    include CanCan::Ability

    attr_accessor :object

    def self.add_extra_ability_class_name(class_name)
      @@extra_classes << class_name.constantize
    end

    def initialize(user)
      self.object = user
      @@extra_classes.each do |extra_class|
        extra_class.new(user, self)
      end

      anonymous and return if user.nil?

      if user.has_role? :superadmin
        can :access, :admin
        can :manage, AuthCore::User
      end

      if user.has_role? :admin_user
        can :access, :admin
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