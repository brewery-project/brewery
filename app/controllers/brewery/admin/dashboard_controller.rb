module Brewery
  class Admin::DashboardController < ApplicationController
    include Admin::BaseController

    def index
      render :index
    end
  end
end