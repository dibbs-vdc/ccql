# Modified from Hyrax Gem 2.0.0

module Hyrax
  module Admin
    class UsersPresenter
      # @return [Array] an array of approved Users
      def users
        @users ||= search_approved
      end

      # @return [Number] quantity of users excluding the system users and guest_users
      def user_count
        users.count
      end

      # @return [Array] an array of pending Users, awaiting approval
      def pending_users
        @pending_users ||= search_pending
      end

      # @return [Number] quantity of pending users excluding the system users and guest_users
      def pending_user_count
        pending_users.count
      end

      # @return [Array] an array of user roles
      def user_roles(user)
        user.groups
      end

      def last_accessed(user)
        user.last_sign_in_at || user.created_at
      end

      protected

        # Returns a list of users excluding the system users and guest_users
        # and other non-approved users
        def search
          search_approved
        end

        # Returns a list of users excluding the system users and guest_users
        # and other non-approved users
        def search_approved
          ::User.registered.without_system_accounts.where(approved: true)
        end

        # Returns a list of users awaiting approval
        def search_pending
          ::User.registered.without_system_accounts.where(approved: false)
        end
    end
  end
end
