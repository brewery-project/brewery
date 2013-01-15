require_dependency "brewery/application_controller"

module Brewery
  class Admin::BaseController < ApplicationController
    before_action do
      authorize! :access, :admin
    end
  end
end