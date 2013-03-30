class MapAssessmentsController < ApplicationController
	include SessionsHelper

	before_filter :require_session

	def create
		Rails.logger.info(params)
	    @map_assessment = MapAssessment.new(params[:map_assessment])
	    @map = Map.find(params[:map_assessment][:map_id])
	    @map.map_assessments << @map_assessment

	    respond_to do |format|
	      if @map_assessment.save and @map.save
	      	Rails.logger.info("Success!!!")
	      	format.html { render :partial => 'maps/list_map_assessments', :locals => { :object => @map } }
	      else
	      	Rails.logger.info("Failure!!!")
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


  	def destroy

  		@map_assessment = MapAssessment.find_by_id_and_user_id( params[:id], @current_user.id)

  		# Stop here if map was not found
  		return render nothing: true, status: 404 if !@map_assessment
	    
	    # Needed to re-render map assessments
	    @map = @map_assessment.map

	    # Removing resource
	    @map_assessment.destroy

	    respond_to do |format|
	      if @map.save
	      	format.html { render :partial => 'maps/list_map_assessments', :locals => { :object => @map } }
	      else
	      	format.html { render nothing: true, status: 500 }
	      end
	    end
  	end 

  	# Requires user session
  	def require_session
    	unless current_user
      		redirect_to signin_path
    	end
  	end

end
