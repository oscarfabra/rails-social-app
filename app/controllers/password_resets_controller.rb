class PasswordResetsController < ApplicationController

  # Calls get_user method before edit and update actions
  before_action :get_user, only: [:edit, :update]

  def new
  end

  # Creates a new password reset and sends an email with reset instructions.
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions."
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found."
      render 'new'
    end
  end

  def edit
  end

  # Updates after user password successfully authenticated.
  def update
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_path
    elsif @user.update_attributes(user_params)
      # If successfully updated user password.
      if (params[:user][:password].blank? && 
          params[:user][:password_confirmation].blank?)
        flash.now[:danger] = "Password/confirmation can't be blank."
        render 'edit'
      else
        flash[:success] = "Password has been reset."
        log_in @user
        redirect_to @user
      end
    else
      # If not successfully updated password.
      render 'edit'
    end
  end

  # Private methods
  private

    # Guarantees strong parameters.
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # Gets the user.
    def get_user
      @user = User.find_by(email: params[:email])
      unless @user && @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end      
    end
end
