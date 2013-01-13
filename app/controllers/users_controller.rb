class UsersController < ApplicationController
  def show
    # Users must be signed in to view a profile
    if !signed_in?
      return_to signin_url
    end

    # Users can only sign in to their own account; ignore params
    @user = @current_user
  end
  
  def new
    if signed_in?
      redirect_to @current_user
    end
    
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = t('signup.welcome', app_name: t('global.app_name'))
      redirect_to @user
    else
      render 'new'
    end
  end
end
