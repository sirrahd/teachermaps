class MapResourcesController < ApplicationController
	include SessionsHelper

	before_filter :require_session

	def update
		@map_resource = MapResource.find_by_id_and_user_id params[:id], @current_user.id

  	respond_to do |format|
    	if @map_resource.update_attributes params[:map_resource] 
      	format.json { respond_with_bip @map_resource  }
	    else
	      format.json { respond_with_bip @map_resource }
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
