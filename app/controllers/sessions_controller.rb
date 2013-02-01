class SessionsController < ApplicationController
  def new
    redirect_to @current_user if signed_in?
  end
  
  def create
    user = User.find_by_email(params[:session][:name].downcase) ||
           User.find_by_account_name(params[:session][:name].downcase)
    
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
    else
      flash.now[:error] = t 'signin.error'
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
end
