module SessionsHelper

  # Logs in the given user using the session method defined by Rails
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    id = session[:user_id]
    @current_user ||= User.find_by(id: id)
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out given user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
