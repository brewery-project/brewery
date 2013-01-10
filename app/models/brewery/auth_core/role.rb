module Brewery
  class AuthCore::Role < ActiveRecord::Base
    has_many :children, class_name: 'AuthCore::Role', foreign_key: :parent_id
    belongs_to :parent, class_name: 'AuthCore::Role'
    has_and_belongs_to_many :users
  end
end
