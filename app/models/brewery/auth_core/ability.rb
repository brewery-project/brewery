module Brewery
  class AuthCore::Ability
    @@extra_classes = []
    include CanCan::Ability

    attr_accessor :object, :extras

    def self.add_extra_ability_class_name(class_name)
      @@extra_classes << class_name.constantize
    end

    def initialize(user, extra_parameters)
      self.object = user
      self.extras = []
      @@extra_classes.each do |extra_class|
        extras << extra_class.new(user, self, extra_parameters)
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

      can :update, user
      can :destroy, AuthCore::UserSession
    end

    private

    def anonymous
      can :manage, AuthCore::UserSession
      can :create, AuthCore::User

      extras.each do |extra|
        extra.anonymous if extra.respond_to?(:anonymous)
      end
    end
  end
end
