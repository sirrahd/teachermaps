class StaticPagesController < ApplicationController
  def home
    redirect_to @current_user if signed_in?
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
