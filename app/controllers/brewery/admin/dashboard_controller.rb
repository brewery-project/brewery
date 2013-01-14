module Brewery
  class Admin::DashboardController < Admin::BaseController

    def index
      render :index
    end
  end
end