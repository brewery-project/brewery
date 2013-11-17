require 'test_helper'

class BreweryTest < ActiveSupport::TestCase
    test "truth" do
        assert_kind_of Module, Brewery
    end

    test "Brewery::ApplicationController derives from ApplicationController" do
        assert_operator Brewery::ApplicationController, :<, ::ApplicationController
    end
end
