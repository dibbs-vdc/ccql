module Hyrax
  module Dashboard
    ## Shows and edit the profile of the current_user
    class ProfilesController < Hyrax::UsersController
      with_themed_layout 'dashboard'
      before_action :find_user
      authorize_resource class: '::User', instance_name: :user

      # Process changes from profile form
      def update
        if conditionally_update
          redirect_to hyrax.dashboard_profile_path(@user.to_param), notice: "Your profile has been updated"
        else
          redirect_to hyrax.edit_dashboard_profile_path(@user.to_param), alert: @user.errors.full_messages
        end
      end

      private

        # Update user if they sent user params, otherwise return true.
        # This is important because this controller is also handling removing trophies.
        # (but we should move that to a different controller)
        def conditionally_update
          return true unless params[:user]
          @user.update(user_params)
        end

        def user_params
          params.require(:user).permit(key_attributes)
        end
  
        def key_attributes
          [:first_name, :last_name, 
           :organization, :organization_other, 
           :department,
           :position, :position_other, 
           {:discipline => []}, :discipline_other, 
           :orcid,
           :address, :email,
           :cv_link, :cv_file, 
           :website,
           :sites_open_science_framework, :sites_open_science_framework_url,
           :sites_researchgate, :sites_researchgate_url,
           :sites_linkedin, :sites_linkedin_url,
           :sites_vivo, :sites_vivo_url,
           :sites_institutional_repo, :sites_institutional_repo_url,
           :sites_other, :sites_other_url]
        end
    end
  end
end
