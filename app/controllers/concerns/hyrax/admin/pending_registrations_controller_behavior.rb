module Hyrax
  module Admin
    module PendingRegistrationsControllerBehavior
      extend ActiveSupport::Concern
      include Blacklight::SearchContext

      # Display admin menu list of users
      def index
        add_breadcrumb t(:'hyrax.controls.home'), root_path
        add_breadcrumb t(:'hyrax.toolbar.admin.menu'), hyrax.admin_path
        add_breadcrumb t(:'hyrax.admin.pending_registrations.index.title'), hyrax.admin_pending_registrations_path
        @presenter = Hyrax::Admin::UsersPresenter.new
      end
    end
  end
end
