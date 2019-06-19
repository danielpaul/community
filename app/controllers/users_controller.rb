class UsersController < ApplicationController
  # authenticate user
  skip_before_action :check_user_setup_completion, only: [:setup, :update]

  before_action :set_current_user

  def index
    redirect_to user_path(current_user.id)
  end

  def show
    @user = User.friendly.find(params[:id])
  end

  def setup
  end

  def edit
  end

  def update
    if @user.update(user_params)
     redirect_to :action => 'show', :id => @user
    else
    end
  end

  def destroy
    if @user.destroy
      redirect_to root_path, notice: 'Account was successfully destroyed.'
    else
      redirect_to root_path, notice: 'Account cannot be destroyed.'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :school_year)
  end

  def set_current_user
    @user = current_user
  end
end
