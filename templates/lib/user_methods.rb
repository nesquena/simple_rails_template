module UserMethods
  
  def require_logged_in
    redirect_to new_user_session_path unless current_user
  end
  
  def require_logged_out
    redirect_to login_success_url if current_user
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
end