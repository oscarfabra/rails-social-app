class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]
    @user = User.find_by(email: email)        # Utilizes an instance variable
    if @user && @user.authenticate(password)
      if @user.activated?
        # Logs in user
        log_in @user
        # Whether to remember the user or not
        remember_user = params[:session][:remember_me]
        (remember_user == '1') ? remember(@user) : forget(@user)
        # Redirects user to previously intended page if any
        redirect_back_or @user
      else
        message = "Account hasn't been activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
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
