module SessionsHelper
  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id]  
  end  

  def current_user?(user)
    current_user == user
  end

  def signed_in?
    !current_user.nil?
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_returns_to
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  private
  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_returns_to
    session[:return_to] = nil
  end
end
