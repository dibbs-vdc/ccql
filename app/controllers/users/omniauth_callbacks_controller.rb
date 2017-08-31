class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def shibboleth
    key = request.env["HTTP_EPPN"]
    @user = User.find_by_user_key(key)
    if @user
      #@user = User.find_or_create_system_user(key)
      sign_in_and_redirect @user
    else
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
