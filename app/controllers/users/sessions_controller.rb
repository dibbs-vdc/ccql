module Users
  class SessionsController < Devise::SessionsController

   protected
   def after_sign_in_path_for(resource)
    hyrax.dashboard_profile_path(resource)
   end
  end
end
