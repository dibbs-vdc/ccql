#TODO: Why do I have so many controllers?

module Hyrax
  class Admin::UsersController < AdminController
    include Hyrax::Admin::UsersControllerBehavior

    def edit
      @user = ::User.find_by(id: params[:id])
    end

   def update
     @user = ::User.find_by(id: params[:id])
     if @user.update(user_admin_params)
       redirect_to hyrax.admin_pending_registrations_path, notice: "Updated registration for #{@user.email}"
     else
       render 'edit'
     end
   end

  private
 
    def user_admin_params
      params.require(:user).permit(key_attributes)
    end

    # TODO: This is a copy of the registrations_controller key attributes.
    #       Is there a way to avoid duplication?
    def key_attributes
      [:vdc_referral_method,:vdc_referral_method_other,:first_name, :last_name, 
       :organization, :organization_other, 
       :department,
       :vdc_role, :vdc_role_other, 
       :discipline, :discipline_other, 
       :orcid,
       :edu_person_principal_name, 
       :address, :email,
       :cv_link, :cv_file, 
       :sites_open_science_framework, :sites_open_science_framework_profile,
       :sites_linkedin, :sites_linkedin_url,
       :sites_vivo, :sites_vivo_url,
       :sites_institutional_repo, :sites_institutional_repo_name,
       :sites_other, :sites_other_url,
       :usage_deposit_files, :usage_use_files, :usage_use_tools_on_vdc_data,
       :usage_use_tools_on_external_data, :usage_contact_others,
       :usage_description,:usage_duration]
    end

  end
end
