class SessionsController < ApplicationController
  def create  
    reset_session
    #raise request.env["omniauth.auth"].to_yaml  
    auth = request.env["omniauth.auth"]  
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"])
    if(user.nil?)
      user = User.create_with_omniauth(auth)
    else
      user.update_user_info(auth)
    end
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Welcome #{user.name}!"
  end  

  def destroy  
    reset_session
    redirect_to root_url, :notice => "Signed out from Micropost!"  
  end

  def failure
    redirect_to root_url, :alert => "Sorry, there was something wrong with your login, try again?"  
  end
end
