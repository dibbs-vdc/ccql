module Hyrax
  module Statistics
    module Vdc
      module SystemStatsOverride

        # returns [Array<user>] a list (of size limit) of users most recently registered with the system
        #
        def recent_users
          # no dates return the top few based on limit
          return ::User.order('created_at DESC').where(approved: true).limit(limit) if start_date.blank?
  
          ::User.recent_users start_date, end_date
        end
      end
    end
  end
end
