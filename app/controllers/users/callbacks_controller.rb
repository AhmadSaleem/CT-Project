class Users::CallbacksController < Devise::OmniauthCallbacksController

  User::SITES.each do |name|
    define_method name do
      social_site
    end
  end

  def social_site
    @user = SocialLogin.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: "#{request.env['omniauth.auth'].provider}"
      sign_in_and_redirect @user
    else
      redirect_to new_user_registration_path, alert: @user.errors.full_messages.join("\n")
    end
  end

end
