class Vdc::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def shibboleth
    eppn = request.env["HTTP_EPPN"]
    users = User.where(['edu_person_principal_name = ?', eppn])
    if users.empty?
      redirect_to new_user_registration_url
    else
      # TODO: What to do if there is more than 1 account with the same eppn? Need to put a unique validation on eppn.
      @user = users.first
      sign_in_and_redirect @user
    end
  end

  def failure
    redirect_to root_path
  end
end
