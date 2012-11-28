class SessionsController < ApplicationController
  def new
  end
  
  def create
  
    # more efficient--string search for @
    user = user.find_by_email(params[:session][:name].downcase) ||
           user.find_by_alias(params[:session][:name].downcase)
    
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
