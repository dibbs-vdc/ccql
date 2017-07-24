class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
 def shibboleth
    @user = User.find_or_create_system_user(request.env["HTTP_EPPN"])
    sign_in_and_redirect @user
  end

  def failure
    redirect_to root_path
  end
end
