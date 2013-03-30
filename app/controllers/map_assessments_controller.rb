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

  	def ajax_show_resources
  		@map_assessment = MapAssessment.find_by_id_and_user_id( params[:id], @current_user.id)

  		return render nothing: true, status: 404 if !@map_assessment

  		@map = @map_assessment.map
	    @resources = Resource.where user_id: @current_user.id
	    @filter_resource_types = ResourceType.all
	    @filter_course_grades = CourseGrade.all
	    @filter_course_subjects = CourseSubject.all   

  		return render :partial => 'maps/modal_resources', :locals => { :object => @map }
  	end


  	def ajax_filter_resources

	    Rails.logger.info("Filter Params: #{params}")

	    filter = {}
	    @resources = Resource.where( :user_id => @current_user.id )

	    if params.has_key?('q') and !params[:q].empty?
	      #@resources &= Resource.where( 'title LIKE ?', "%#{params[:q].strip}%" )
	      @resources &= Resource.where( Resource.arel_table[:title].matches("%#{params[:q].strip}%") )
	    end

	    if params.has_key?('resource_types')
	      @resources &= Resource.find(:all, :conditions=>{:user_id => @current_user.id, :resource_type_id=>params[:resource_types]})
	    end

	    if params.has_key?('course_grades')
	      @resources &= Resource.find(:all, :joins => :course_grades, :conditions=>{:user_id => @current_user.id, :course_grades=>{:id => params[:course_grades]}})
	      
	    end

	    if params.has_key?('course_subjects')
	      @resources &= Resource.find(:all, :joins => :course_subjects, :conditions=>{:user_id => @current_user.id, :course_subjects=>{:id => params[:course_subjects]}})
	    end

	    Rails.logger.info(@resources);
	    render :partial => 'map_assessments/table_resources'
	end

	private

  	# Requires user session
  	def require_session
    	unless current_user
      		redirect_to signin_path
    	end
  	end

end
