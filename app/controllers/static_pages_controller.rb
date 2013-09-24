class StaticPagesController < ApplicationController
	include ApplicationHelper

  def home
    if signed_in?
      redirect_to @current_user
    elsif params[:mvp]
      render 'static_pages/home'
    elsif params[:login]
      render 'launchlogin', layout: false
    else
      # render 'launchpage', layout: false
      render 'launchpage'
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


  def videos
  end

  def page404
  	render '404'
  end

  def page500
  	render '500'
  end

  def robots
  	if is_main_proudction?
	  	robots = File.read(Rails.root + "config/robots/production.txt")
	  else
	  	robots = File.read(Rails.root + "config/robots/development.txt")
	  end
	  Rails.logger.info "Is is_main_proudction? #{is_main_proudction?}"
	  render :text => robots, :layout => false, :content_type => "text/plain"
	end
end
