class MapObjectivesController < ApplicationController
  include SessionsHelper

  before_filter :require_session

  def create

    Rails.logger.info(params)
   
    return render :nothing => true, :status => 403 if !@current_user 
    
    @map_standard = MapStandard.find_by_id_and_user_id(params[:map_standard_id], @current_user.id) 
    if !@map_standard
      Rails.logger.info("Could not locate map standard #{params[:map_standard_id]}") 
      return render :nothing => true, :status => 404
    end

    @map = @map_standard.map
    Rails.logger.info("Located Map Standard #{@map_standard.slug} in Map #{@map.slug}")

    @map_objective = MapObjective.new
    @map_objective.map_standard = @map_standard
    @map_objective.map = @map
    @map_objective.user = @current_user

    @map_standard.map_objectives << @map_objective

    @map.objectives_count += 1
    @map.save

    respond_to do |format|
      if @map_objective.save and @map.save
        Rails.logger.info("Success in creating map objctive!!!")
        format.html { render :partial => 'map_standards/list_map_objectives'}
      else
        Rails.logger.info("Failure in creating map objective!!! #{@map_objectives.errors} :: #{@map.errors}")
        format.html { render :json => @map_assessment.errors, :status => :unprocessable_entity  }
      end
    end

  end

  def destroy
    @map_objective = MapObjective.find_by_id_and_user_id( params[:id], @current_user.id )
    # Stop here if map was not found
    return render nothing: true, status: 404 if !@map_objective

    @map_standard = @map_objective.map_standard
    
    # Needed to re-render map assessments
    @map = @map_objective.map
    @map.objectives_count -= 1
    @map.resources_count -= @map_objective.map_resources.count

    # Removing resource
    @map_objective.destroy


    respond_to do |format|
      if @map.save
        format.html { render :partial => 'map_standards/list_map_objectives'}
      else
        format.html { render nothing: true, status: 500 }
      end
    end
  end 


  def update
    @map_objective = MapObjective.find params[:id]

    respond_to do |format|
      if @map_objective.update_attributes(params[:map_objective])
          format.html { redirect_to(@map_objective, :notice => 'Map Objective was successfully updated.') }
          format.json { respond_with_bip(@map_objective) }
      else
          format.html { render :action => "edit" }
          format.json { respond_with_bip(@map_objective) }
      end
    end
  end


  def show_resources
    @map_objective = MapObjective.find_by_id_and_user_id( params[:map_objective_id], @current_user.id)

    return render nothing: true, status: 404 if !@map_objective

    @map = @map_objective.map
    @resources = Resource.where user_id: @current_user.id
    @filter_resource_types = ResourceType.all
    @filter_course_grades = CourseGrade.all
    @filter_course_subjects = CourseSubject.all   
    @map_resources_by_resource_id = Hash[@map_objective.map_resources.map { |p| [p['resource_id'], p] }]
    Rails.logger.info("Map Objectives Ressources: #{@map_resources_by_resource_id.inspect}")

    return render :partial => 'map_standards/modal_resources'
  end


  def filter_resources

      Rails.logger.info("Filter Params: #{params}")
      @map_objective = MapObjective.find(params[:map_objective_id])

      return render nothing: true, status: 404 if !@map_objective
      
      @map_resources_by_resource_id = Hash[@map_objective.map_resources.map { |p| [p['resource_id'], p] }]
      Rails.logger.info("Map Objective Ressource: #{@map_resources_by_resource_id.inspect}")

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
      render :partial => 'map_standards/table_resources'
  end

  def create_resource

      Rails.logger.info(params)
      @map_objective = MapObjective.find(params[:map_objective_id])
      @resource = Resource.find(params[:resource_id])

      if !@map_objective or !@resource
        Rails.logger.info("Could not locate either map objective #{params[:map_objective_id]} or resource #{params[:resource_id]}") 
        return render :nothing => true, :status => 404
      end

      Rails.logger.info("User: #{@current_user.id} MapObjective: #{@map_objective.user_id} Resource: #{@resource.user_id}")
      if @map_objective.user_id != @current_user.id or @resource.user_id != @current_user.id
        Rails.logger.info("User does not have permission to add this resource") 
        return render :nothing => true, :status => 403
      end

      @map_standard = @map_objective.map_standard
      @map = @map_objective.map

      if !MapResource.find_by_map_objective_id_and_resource_id(@map_objective, @resource)
        @map_resource = MapObjectiveResource.new
        @map_resource.user = @current_user
        @map_resource.map = @map_objective.map
        @map_resource.resource = @resource
        @map_resource.map_objective = @map_objective
        
        @map_objective.map_resources << @map_resource

        @map.resources_count +=1 
      end

      respond_to do |format|
        if @map_resource.save and @map.save
          format.html { render :partial => 'map_standards/list_map_objectives'}
        else
          Rails.logger.info("Errors: #{@map_resource.errors.inspect} #{@map_objective.errors.inspect}")
          format.html { render nothing: true, status: 500 }
        end
      end
  end

  def destroy_resource
    Rails.logger.info(params)
    @map_objective = MapObjective.find(params[:map_objective_id])
    @resource = Resource.find(params[:resource_id])

    if !@map_objective or !@resource
      Rails.logger.info("Could not locate either map objective #{params[:map_objective_id]} or resource #{params[:resource_id]}") 
      return render :nothing => true, :status => 404
    end

    Rails.logger.info("User: #{@current_user.id} Map Objective: #{@map_objective.user_id} Resource: #{@resource.user_id}")
    if !@map_objective.owned_by?(@current_user.id) or !@resource.owned_by?(@current_user.id)
      Rails.logger.info("User does not have permission to remove this resource") 
      return render :nothing => true, :status => 403
    end

    @map_standard = @map_objective.map_standard
    @map = @map_objective.map
    @map.resources_count -= 1

    @map_resource = MapResource.find_by_map_objective_id_and_resource_id(@map_objective, @resource)
    @map_resource.destroy

    Rails.logger.info("Deleted map resource")

    respond_to do |format|
      if @map_resource.destroyed? and @map.save
        format.html { render :partial => 'map_standards/list_map_objectives' }
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
