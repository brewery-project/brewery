module Brewery
  module Admin::BaseController
    extend ActiveSupport::Concern
    included do
      before_action do
        authorize! :access, :admin
      end
      layout 'brewery/admin'

      before_filter :add_base_crumb

      rescue_from ActiveRecord::RecordNotFound do |ex|
        flash.now[:error] = ex.message

        instance_variable_set("@#{self.class.resource_name.pluralize}", self.class.resource_class.paginate(page: params['page']))
        render :index, status: 404
      end

      protected
      def self.load_and_protect
        self.load_and_authorize_resource class: self.resource_class
      end

      def self.resource_name
        self.name.sub(/Controller$/, '').underscore.split('/').last.singularize
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