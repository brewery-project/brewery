module Brewery
  module Admin::BaseController
    extend ActiveSupport::Concern
    included do
      before_action :authorize_admin_access
      layout 'brewery/admin'

      before_action :add_base_crumb

      rescue_from ActiveRecord::RecordNotFound do |ex|
        flash.now[:error] = ex.message

        instance_variable_set("@#{self.class.resource_name.pluralize}",
                               self.class.resource_class.accessible_by(current_ability).paginate(page: params['page']))
        render :index, status: 404
      end

      def authorize_admin_access
        authorize! :access, :admin
      end

      protected
      def self.load_and_protect
        self.load_and_authorize_resource class: self.resource_class
      end

      def self.resource_name
        self.name.sub(/Controller$/, '').underscore.split('/').last.singularize
      end

      def self.register_admin_crumbs
        self.before_action :index_crumb, except: [:index]
        self.before_action :on_index_crumb, only: [:index]
        self.before_action :on_show_crumb, only: [:show]
        self.before_action :on_edit_crumb, only: [:edit, :update]
        self.before_action :on_new_crumb, only: [:new, :create]
      end

      def index_crumb
        add_crumb(crumb_module.title, crumb_module.index_path)
      end

      def on_index_crumb
        add_crumb(crumb_module.title)
      end

      def on_show_crumb
        add_crumb(crumb_module.label)
      end

      def on_edit_crumb
        add_crumb(crumb_module.label, crumb_module.object_path)
        add_crumb(I18n.t('brewery.general.actions.edit'))
      end

      def on_new_crumb
        add_crumb(I18n.t('brewery.general.actions.create'))
      end

      private
      def add_base_crumb
        add_crumb I18n.t('brewery.admin.title'), brewery.admin_path
      end

      def self.resource_class
        self.name.sub(/Controller$/, '').                 # Remove Controller
                  underscore.
                  split('/').
                  delete_if { |x| x == 'admin' }.         # Remove admin from namespace
                  join('/').
                  singularize.camelize.constantize        # And as a result retrieve the full model
      end
    end
  end
end
