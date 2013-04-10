class MapResourcesController < ApplicationController

	def update
		Rails.logger.info(params)
		@map_resource = MapResource.find params[:id]
		Rails.logger.info(@map_resource)
  	respond_to do |format|
    	if @map_resource.update_attributes(params[:map_resource])
      		format.html { redirect_to(@map_resource, :notice => 'MapResource was successfully updated.') }
	      	format.json { respond_with_bip(@map_resource) }
	    else
	      	format.html { render :action => "edit" }
	      	format.json { respond_with_bip(@map_resource) }
	    end
		end
	end

end
