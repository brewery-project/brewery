require_dependency "brewery/application_controller"

module Brewery
  class Admin::BaseController < ApplicationController
    before_action do
      if current_user.nil?
        redirect_to brewery.auth_core_login_url, error: I18n.t('brewery.auth_core.sessions.permission_denied_anonymous')
        return
      end

      if !current_user.has_role?(:admin)
        redirect_to main_app.root_url, error: I18n.t('brewery.auth_core.sessions.permission_denied')
      end
    end
  end
end