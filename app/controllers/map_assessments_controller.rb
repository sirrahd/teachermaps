class MapAssessmentsController < ApplicationController
	include SessionsHelper

	before_filter :require_session

	def create
		Rails.logger.info(params)
    @map_assessment = MapAssessment.new( map_id: params[:map_id])
    @map_assessment.user = @current_user
    @map = @map_assessment.map
  
    respond_to do |format|
      if @map_assessment.save
      	format.html { render :partial => 'maps/list_map_assessments'}
      else
      	Rails.logger.info("Create Map Assessment errror #{@map_assessment.errors.messages}")
      	format.html { render :json => @map_assessment.errors, :status => :unprocessable_entity  }
      end
    end
	end

	def update
		@map_assessment = MapAssessment.find params[:id]

  	respond_to do |format|
    	if @map_assessment.update_attributes(params[:map_assessment])
	      format.json { respond_with_bip(@map_assessment) }
	    else
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
      if @map_assessment.destroyed?
      	format.html { render partial: 'maps/list_map_assessments' }
      else
        Rails.logger.info("Destroy Map Assessment errror #{@map_assessment.errors.messages}")
      	format.html { render :json => @map_assessment.errors, :status => :unprocessable_entity }
      end
    end
	end 

	def show_resources
		@map_assessment = MapAssessment.find_by_id_and_user_id( params[:id], @current_user.id)

		return render nothing: true, status: 404 if !@map_assessment

		@map = @map_assessment.map
    @resources = Resource.where user_id: @current_user.id
    @filter_resource_types = ResourceType.all
    @filter_course_grades = CourseGrade.all
    @filter_course_subjects = CourseSubject.all   
    @map_resources_by_resource_id = Hash[@map_assessment.map_resources.map { |p| [p['resource_id'], p] }]
    Rails.logger.info("Map Assessment Ressource: #{@map_resources_by_resource_id.inspect}")

		return render :partial => 'maps/modal_map_assessment_resources'
	end


	def filter_resources

    Rails.logger.info("Filter Params: #{params}")
    @map_assessment = MapAssessment.find(params[:map_assessment_id])

    return render nothing: true, status: 404 if !@map_assessment
    
    @map_resources_by_resource_id = Hash[@map_assessment.map_resources.map { |p| [p['resource_id'], p] }]
    	Rails.logger.info("Map Assessment Ressource: #{@map_resources_by_resource_id.inspect}")

    filter = {}
    @resources = Resource.where( :user_id => @current_user.id )

    if params.has_key?('q') and !params[:q].empty?
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
    render :partial => 'maps/table_map_assessment_resources'
	end


	def ajax_new_resource

	    Rails.logger.info(params)
	    @map_assessment = MapAssessment.find(params[:map_assessment_id])
	    @resource = Resource.find(params[:resource_id])

	    if !@map_assessment or !@resource
	      Rails.logger.info("Could not locate either map assessment #{params[:map_assessment_id]} or resource #{params[:resource_id]}") 
	      return render :nothing => true, :status => 404
	    end

	    Rails.logger.info("User: #{@current_user.id} MapAssessment: #{@map_assessment.user_id} Resource: #{@resource.user_id}")
	    if @map_assessment.user_id != @current_user.id or @resource.user_id != @current_user.id
	      Rails.logger.info("User does not have permission to add this resource") 
	      return render :nothing => true, :status => 403
	    end

	    @map = @map_assessment.map

	    if !MapResource.find_by_map_assessment_id_and_resource_id(@map_assessment, @resource)
	    	@map_resource = MapAssessmentResource.new
	    	@map_resource.user = @current_user
	    	@map_resource.map = @map
	    	@map_resource.resource = @resource
	    	@map_resource.map_assessment = @map_assessment

	   	end

	    respond_to do |format|
	      if @map_resource.save and @map_assessment.save
	      	format.html { render :partial => 'maps/list_map_assessments'}
	      else
	      	Rails.logger.info("Errors: #{@map_resource.errors.inspect} #{@map_assessment.errors.inspect}")
	      	format.html { render nothing: true, status: 500 }
	      end
	    end
	end

	def ajax_destroy_resource
		Rails.logger.info(params)
	    @map_assessment = MapAssessment.find(params[:map_assessment_id])
	    @resource = Resource.find(params[:resource_id])

	    if !@map_assessment or !@resource
	      Rails.logger.info("Could not locate either map assessment #{params[:map_assessment_id]} or resource #{params[:resource_id]}") 
	      return render :nothing => true, :status => 404
	    end

	    Rails.logger.info("User: #{@current_user.id} MapAssessment: #{@map_assessment.user_id} Resource: #{@resource.user_id}")
	    if @map_assessment.user_id != @current_user.id or @resource.user_id != @current_user.id
	      Rails.logger.info("User does not have permission to add this resource") 
	      return render :nothing => true, :status => 403
	    end

	    @map = @map_assessment.map

	    @map_resource = MapResource.find_by_map_assessment_id_and_resource_id(@map_assessment, @resource)
	    @map_resource.destroy

	    Rails.logger.info("Deleted map resource @map_resource.name")

	    respond_to do |format|
	      if @map_resource.destroyed? and @map.save
	      	format.html { render :partial => 'maps/list_map_assessments', :locals => { :object => @map } }
	      else
	      	Rails.logger.info("Errors: #{@map_resource.errors.inspect}")
	      	format.html { render nothing: true, status: 500 }
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
