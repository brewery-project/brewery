module Brewery
  class AuthCore::Role < ActiveRecord::Base
    has_and_belongs_to_many :users

    belongs_to :authorizable, polymorphic: true

    scope :assignable, Proc.new { where(hidden: false) }

    def i18n_name
      return I18n.t name, scope: [:brewery, :auth_core, :role, :names]
    end
  end
end
