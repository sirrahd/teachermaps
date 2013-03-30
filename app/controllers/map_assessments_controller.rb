class MapAssessmentsController < ApplicationController

	def update
		@map_assessment = MapAssessment.find params[:id]

	  	respond_to do |format|
	    	if @map_assessment.update_attributes(params[:map_assessment])
	      		format.html { redirect_to(@map_assessment, :notice => 'MapAssessment was successfully updated.') }
		      	format.json { respond_with_bip(@map_assessment) }
		    else
		      	format.html { render :action => "edit" }
		      	format.json { respond_with_bip(@map_assessment) }
		    end
  		end
  	end

end
