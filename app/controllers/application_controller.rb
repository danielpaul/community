class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :check_user_setup_completion

  private

  def user_not_authorized
    redirect_to(request.referrer || root_path)
    flash[:warning] = "You are not authorized to perform this action."
  end

  def check_user_setup_completion
    if user_signed_in? && !current_user.setup_complete?
      redirect_to setup_path and return
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

end
