class ApplicationController < ActionController::Base
  before_action :check_user_setup_completion

  private

  def check_user_setup_completion
    if user_signed_in? && !current_user.setup_complete?
      redirect_to setup_path and return
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

end
