class MapResourcesController < ApplicationController

	def update
		@map_resources = MapResource.find params[:id]

	  	respond_to do |format|
	    	if @map_resources.update_attributes(params[:map_resources])
	      		format.html { redirect_to(@map_resources, :notice => 'MapResource was successfully updated.') }
		      	format.json { respond_with_bip(@map_resources) }
		    else
		      	format.html { render :action => "edit" }
		      	format.json { respond_with_bip(@map_resources) }
		    end
  		end
  	end

end
