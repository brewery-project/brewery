require 'test_helper'

class BreweryTest < ActiveSupport::TestCase
    test "truth" do
        assert_kind_of Module, Brewery
    end

    test "Brewery::ApplicationController derives from ApplicationController" do
        assert_operator Brewery::ApplicationController, :<, ::ApplicationController
    end

    test "Brewery::ApplicationController::Base is a Module" do
        assert_kind_of Module, Brewery::ApplicationController::Base
    end

     test "Brewery::Admin::BaseController is a Module" do
        assert_kind_of Module, Brewery::Admin::BaseController
    end
end
