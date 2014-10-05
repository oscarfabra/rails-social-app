module SessionsHelper

  # Logs in the given user using the session method defined by Rails
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    # Generates a remember token and saves its digest to the database
    user.remember
    # Uses Rails cookies to create permanent cookies for the user id and 
    # remember token
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Returns true if the given user is the current user
  def current_user?(user)
    user == current_user    
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    # If session of user id exists
    if(user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    # If there's a cookie in the browser for this user
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      # If user was found and is authenticated, log it in and save current_user
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end      
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
