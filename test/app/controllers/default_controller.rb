class DefaultController < ApplicationController
  
  def index
    if logged_in?
      redirect_to user_path(current_user.login)
    else
      redirect_to login_path
    end
  end
  
end