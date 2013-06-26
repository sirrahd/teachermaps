class StaticPagesController < ApplicationController
  def home
    if signed_in?
      redirect_to @current_user
    elsif params[:mvp]
      render 'static_pages/home'
    elsif params[:login]
      render 'launchlogin', layout: false
    else
      render 'launchpage', layout: false
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def tos
  end

  def page404
  end

  def page500
  end
end
