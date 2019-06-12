class ApplicationController < ActionController::Base
  before_action :check_user_setup_completion

  private

  def check_user_setup_completion
    if user_signed_in? && !current_user.setup_complete?
      redirect_to setup_path and return
    else
      redirect_to root_path and return
    end
  end

end
