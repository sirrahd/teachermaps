class ShareEmailController < ApplicationController

  def create
  	Rails.logger.info params
  	require_session

  	@email = ShareEmail.new(params[:share_email])
		Rails.logger.info @email.inspect
  	Rails.logger.info @email.valid?

  	@map = Map.find params[:map_id]
  	unless @map
  		Rails.logger.info "Could not email map because no map id was given"
  		format.js { render json: '', status: :unprocessable_entity }
  	end

    respond_to do |format|
      if @email.valid?
	      ShareEmailMailer.share_map_email(@current_user, @email, @map, request.env['HTTP_HOST']).deliver
	      format.js { render json: '', status: :created }
	    else
	    	format.js { render partial:  'shared/error_messages', :locals => { :object => @email }, :status => :unprocessable_entity  }
	    end
    end
    
  end

  private 
  
  # Requires user session
  def require_session
    unless current_user
      redirect_to signin_path
    end
  end
end
