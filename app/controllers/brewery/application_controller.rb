module Brewery
  class ApplicationController < ActionController::Base
    add_flash_types :error, :success, :info
  end
end
