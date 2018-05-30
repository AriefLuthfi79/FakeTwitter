module SessionsHelper
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Strore the user id to the session
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user?(user)
    user == current_user
  end
  
  # Returns the current user if any
  # Returns the user corresponding to the remember token cookie
  def current_user
    if (user_id = session[:user_id]) 
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the user logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end

  # Log out the current user if he/she logged in
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Forgets a user if any by deleting cookie
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_location] || default)
    session.delete(:forwarding_location)
  end
  
  # Store the URL trying to be accessed
  def store_location_url
    session[:forwarding_location] = request.url if request.get?
  end
end
