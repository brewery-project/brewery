module Brewery
  class Admin::DashboardController < ApplicationController
    before_action do
      authorize! :access, :admin
    end
    layout 'brewery/admin'

    @@modules = []
    11.times do |i|
        @@modules << []
    end

    class GoToSiteAdminModule
        def self.title
            return I18n.t('brewery.admin.dashboard.go_to_site')
        end

        def self.link(context)
            context.main_app.root_path
        end

        def self.can?(ability)
            return true
        end

        def self.glyphicon
            return 'home'
        end

        def self.search(query)
            []
        end
    end

    def index
        @dashboard_modules = @@modules.flatten.select { |a_module| a_module.can?(current_ability) }
        render :index
    end

    def search
        dashboard_modules = @@modules.flatten.select { |a_module| a_module.can?(current_ability) }
        @search_results = dashboard_modules.map { |m| [m, m.search(params[:q]) ] }

        render :search
    end

    def self.register_module(dashboard_module, priority)
        @@modules[priority] << dashboard_module
    end

    register_module(GoToSiteAdminModule, 10)
  end
end