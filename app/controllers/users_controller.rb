class UsersController < ApplicationController
  # authenticate user
  skip_before_action :check_user_setup_completion, only: [:setup]

  before_action :set_current_user

  def index
    # redirect to current user show
  end

  def show
    @user = User.friendly.find(params[:id])
  end

  def setup
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
     redirect_to :action => 'show', :id => @patient
    else
     index
    end
  end

  def destroy
    @user.destroy
  end

  private

  def set_current_user
    @user = current_user
  end
end
