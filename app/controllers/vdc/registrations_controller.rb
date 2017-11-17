class Vdc::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
    # Expire data after sign in because users are not approved by default
    expire_data_after_sign_in!
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  #def update
  #  super
  #end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # TODO: Make sure that we cancel when registrations are cancelled....
  # Or, after registration is completed, but the user is logged off pending approval.

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_data_after_sign_in!
    flash[:notice] = 'Registration has been canceled.'
    redirect_to root_path 
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: key_attributes)
  end

  def key_attributes
    [:vdc_referral_method,:vdc_referral_method_other,:first_name, :last_name, 
     :organization, :organization_other, 
     :department,
     :position, :position_other, 
     {:discipline => []}, :discipline_other, 
     :orcid,
     :edu_person_principal_name, 
     :address, :email,
     :website,
     :cv_link, :cv_file, 
     :sites_open_science_framework, :sites_open_science_framework_url,
     :sites_researchgate, :sites_researchgate_url,
     :sites_linkedin, :sites_linkedin_url,
     :sites_vivo, :sites_vivo_url,
     :sites_institutional_repo, :sites_institutional_repo_url,
     :sites_other, :sites_other_url,
     :usage_deposit_files, :usage_use_files, :usage_use_tools_on_vdc_data,
     :usage_use_tools_on_external_data, :usage_contact_others,
     :usage_description,:usage_duration]
  end

  # If you have extra params to permit, append them to the sanitizer.
  #def configure_account_update_params
  #  devise_parameter_sanitizer.permit(:account_update, keys: key_attributes)
  #end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
