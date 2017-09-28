class ApplicationController < ActionController::Base
  protect_from_forgery prepend: :true

  def authenticate_active_admin_user!
    authenticate_user!
    redirect_to root_path unless current_user.admin?
  end

  def current_admin_user
    return nil if user_signed_in? && !current_user.admin?
    current_user
  end
end
