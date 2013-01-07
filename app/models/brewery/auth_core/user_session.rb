module Brewery
  class AuthCore::UserSession < Authlogic::Session::Base
    logout_on_timeout true
    disable_magic_states true
  end
end