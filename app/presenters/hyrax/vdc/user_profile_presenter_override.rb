# Attempting to override from Hyrax Gem 2.0.0:
#   app/presenters/hyrax/user_profile_presenter.rb
#
# - Adding additional full_name method

module Hyrax
  module Vdc
    module UserProfilePresenterOverride
      def full_name
        "#{@user.last_name}, #{@user.first_name}"
      end
    end
  end
end
