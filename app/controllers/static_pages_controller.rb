class StaticPagesController < ApplicationController
  def home
    if signed_in?
      redirect_to @current_user
    elsif params[:key] and params[:key] == '8ecea1b34a571c18e8a98130cb619117'
      render 'static_pages/home'
    else
      render 'static_pages/launchpage', layout: false
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
end
