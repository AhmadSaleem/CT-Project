class Users::RegistrationsController < Devise::RegistrationsController

  private
    def sign_up_params
      params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
    end
    def update_resource(resource, params)
      resource.update_without_password(update_params)
    end

    def update_params
      params.require(:user).permit(:user_name, :email)
    end
end
