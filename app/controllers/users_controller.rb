class UsersController < ApplicationController
  def show
    if !(@user = User.find_by_alias(params[:id]))
      @user = User.find(params[:id])
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = t('signup.welcome', app_name: t('global.app_name'))
      redirect_to @user.friendly_link
    else
      render 'new'
    end
  end
end
