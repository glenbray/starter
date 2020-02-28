class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]

    user = User.from_omniauth(auth)

    sign_in(:user, user)

    redirect_to after_sign_in_path_for(user)
  end
end
