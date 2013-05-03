class SessionsController < ApplicationController
  def new
    redirect_to @current_user if signed_in?

    @user = User.new
  end

  def create
    user = User.find_by_email(params[:session][:name].downcase) ||
           User.find_by_account_name(params[:session][:name].downcase)

    if user && user.authenticate(params[:session][:password])
      sign_in user
      if params[:email_request_key]
        redirect_to controller: :users, action: :confirm_email, key: params[:email_request_key]
      else
        redirect_to user
      end
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
