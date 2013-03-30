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
	    map_resources = @map_assessment.map_resources
	    @map_resources_by_resource_id = Hash[map_resources.map { |p| [p['resource_id'], p] }]
      	Rails.logger.info("Map Assessment Ressource: #{@map_resources_by_resource_id.inspect}")

  		return render :partial => 'maps/modal_resources', :locals => { :object => @map }
  	end


  	def ajax_filter_resources

	    Rails.logger.info("Filter Params: #{params}")

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
	    render :partial => 'map_assessments/table_resources'
	end


	def ajax_new

	    Rails.info.logger(params)

	    @map = Map.find_by_id_and_user_id(params[:map_id], @current_user.id)
	    standard = Standard.find(params[:standard_id])

	    if !@map or !standard
	      Rails.logger.info("Could not locate either map #{params[:map_id]} or standard #{params[:standard_id]}") 
	      return render :nothing => true, :status => 404
	    end

	    Rails.logger.info("Located Map #{@map} and Standard #{standard}")

	    if !MapStandard.find_by_standard_id_and_map_id_and_user_id(standard.id, @map.id, @current_user.id)
	        new_map_standard = MapStandard.new
	        new_map_standard.standard = standard
	        new_map_standard.map = @map
	        new_map_standard.user = @current_user
	        @map.map_standards << new_map_standard
	    end

	    # Add any children standards
	    standard.children_standards.each do |child_standard|
	      # Enforce prevention of the same standard being added twice
	      if !MapStandard.find_by_standard_id_and_map_id_and_user_id(child_standard.id, @map.id, @current_user.id)
	        new_map_standard = MapStandard.new
	        new_map_standard.standard = child_standard
	        new_map_standard.map = @map
	        new_map_standard.user = @current_user
	        @map.map_standards << new_map_standard
	      end
	    end

	    return render partial: 'maps/map_standards_list'
	end

	def ajax_destroy
		if !@current_user 
	      return render :nothing => true, :status => 403
	    end
	    if !params.has_key?('map_id') or !params.has_key?('standard_id')
	      return render :nothing => true, :status => 404
	    end

	    print params

	    @map = Map.find_by_id_and_user_id(params[:map_id], @current_user.id)
	    standard = Standard.find(params[:standard_id])
	    map_standard = MapStandard.find_by_standard_id_and_map_id_and_user_id(params[:standard_id], @map.id, @current_user.id)

	    if !@map or !standard or !map_standard
	      Rails.logger.info("Could not locate either map standard from given data") 
	      return render :nothing => true, :status => 404
	    end

	    map_standard.destroy

	    Rails.logger.info("Deleted map standard")

	    return render partial: 'maps/map_standards_list'
	end

	private

  	# Requires user session
  	def require_session
    	unless current_user
      		redirect_to signin_path
    	end
  	end

end
