class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    # If user was created, not yet activated and authenticated correctly
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # Activate user
      user.activate
      # Show message
      flash[:success] = "Account activated!"
      log_in user
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
