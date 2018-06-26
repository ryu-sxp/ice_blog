module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    remember_token_expires_at = 1.months.from_now.utc
    user.remember(remember_token_expires_at)
    cookies.signed[:user_id] = { value: user.id,
                                 expires: remember_token_expires_at }
    cookies[:remember_token] = { value: user.remember_token,
                                 expires: remember_token_expires_at }
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id)
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by(id: user_id)
      if user && user.is_remembered?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def forget(user)
    user.forget(cookies[:remember_token])
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def new_visitor?
    unless session[:visitor_status]
      session[:visitor_status] = 1
      return true
    end
    false
  end

end
