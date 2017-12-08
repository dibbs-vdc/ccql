# Attempting to override from Hyrax Gem 2.0.0:
#   Hyrax::Admin::DashboardPresenter
# This is necessary to make sure that the Admin dashboard shows the 
# correct number of registered users, without counting the ones yet
# to be approved.

module Hyrax
  module Admin
    module Vdc
      module DashboardPresenterOverride
        # @return [Fixnum] the number of currently registered and approved users
        def user_count
          ::User.where(guest: false).where(approved: true).count
        end

        def pending_users
          @pending_users ||= Admin::PendingUsersPresenter.new
        end
      end
    end
  end
end
