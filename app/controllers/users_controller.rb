class UsersController < ApplicationController
  include SessionsHelper
  
  def show
    @user = User.find_by_account_name(params[:id]) || User.find(params[:id])
    
    Rails.logger.info("CurrentUser: #{@current_user}")
    if !signed_in?
      # User not signed in, signin foo!!
      return redirect_to signin_url
    end

    if @current_user.id != @user.id
      # Currently, all acounts are private
      return redirect_to "#{users_url}/#{@current_user.id}"
    end



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
