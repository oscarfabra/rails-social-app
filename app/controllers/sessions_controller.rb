class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    user = User.find_by(email: email)
    if user && user.authenticate(password)
      log_in user
      remember user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  # Logs user out and redirects it to the home page
  def destroy
    log_out if logged_in?   # To avoid user logging out from multiple windows
    redirect_to root_url
  end
end
