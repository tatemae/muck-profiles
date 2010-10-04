class UsersController < Muck::UsersController

  def signup_complete
    redirect_to profiles_path
  end

end