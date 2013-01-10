class UsersController < ApplicationController
  def show
    @user = User.find_by_account_name(params[:id]) || User.find(params[:id])
  end # More efficient look for int
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = t('signup.welcome', app_name: t('global.app_name'))
      redirect_to @user.friendly_link
    else
      render 'new'
    end
  end
end
