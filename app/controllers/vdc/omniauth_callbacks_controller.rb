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

  def openid_connect
    # you need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user
      set_flash_message(:notice, :success, kind: "CILogon")
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
    else
      session["devise.openid_connect_data"] = request.env["omniauth.auth"].except(:extra) # removing extra as it can overflow some session stores
      redirect_to new_user_registration_url, notice: 'Please register and wait for approval before using CILogin'
    end
  end

  def failure
    redirect_to root_path
  end
end
