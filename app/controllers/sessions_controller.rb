class SessionsController < ApplicationController
  skip_before_action :ensure_current_user

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
    if @user && @user.password == params[:user][:password]
      session[:user_id] = @user.id
      # @user.erase_logins
      p "You're Super smart"
      redirect_to root_path
    else
      render :new
    end
  end
end
