class MapAssessmentsController < ApplicationController


	def create
		Rails.logger.info(params)
	    @map_assessment = MapAssessment.new(params[:map_assessment])
	    @map = Map.find(params[:map_assessment][:map_id])
	    @map.map_assessments << @map_assessments

	    respond_to do |format|
	      if @map_assessment.save and @map.save
	      	format.html { render :partial => 'maps/list_map_assessments', :locals => { :object => @map } }
	      else
	      	format.html { render :json => @map_assessment.errors, :status => :unprocessable_entity  }
	      end
	    end
	end

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
