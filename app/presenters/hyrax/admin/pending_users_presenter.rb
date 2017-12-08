module Hyrax
  module Admin
    class PendingUsersPresenter
      # @return [Array] an array of Users                                                                                                                                      
      def pending_users
        @pending_users ||= search_pending
      end

      # @return [Number] quantity of users excluding the system users and guest_users                                                                                          
      def pending_user_count
        pending_users.count
      end

      def last_accessed(pending_user)
        pending_user.last_sign_in_at || pending_user.created_at
      end

      private

        # Returns a list of users excluding the system users and guest_users                                                                                                    
        def search_pending
          ::User.not_approved
        end
    end
  end
end
