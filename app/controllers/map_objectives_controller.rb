class MapObjectivesController < ApplicationController
  include SessionsHelper

  before_filter :require_session

  def create
    Rails.logger.info(params)
    @map_standard = MapStandard.find_by_id_and_user_id(params[:map_standard_id], @current_user.id) 
    
    if !@map_standard
      Rails.logger.info("error 404 map_standard #{params[:map_standard_id]}") 
      return render nothing: true, status: 404
    end

    @map_objective = MapObjective.new 
    @map_objective.map_standard = @map_standard
    @map_objective.map = @map_standard.map
    @map_objective.user = @current_user

    respond_to do |format|
      if @map_objective.save
        format.html { render partial: 'map_standards/list_map_objectives'}
      else
        Rails.logger.info("error create map_objective #{@map_objective.id}")
        format.html { render json: @map_objective.errors, status: :unprocessable_entity  }
      end
    end

  end

  def destroy
    @map_objective = MapObjective.find_by_id_and_user_id params[:id], @current_user.id
    return render nothing: true, status: 404 if !@map_objective

    @map_standard = @map_objective.map_standard
    @map = @map_objective.map
    @map_objective.destroy

    respond_to do |format|
      if @map_objective.destroyed?
        format.html { render partial: 'map_standards/list_map_objectives'}
      else
        Rails.logger.info("error delete map_objective #{@map_objective.id}")
        format.html { render json: @map_objective.errors, status: :unprocessable_entity  }
      end
    end
  end 

  def update
    @map_objective = MapObjective.find_by_id_and_user_id params[:id], @current_user.id

    respond_to do |format|
      if @map_objective.update_attributes(params[:map_objective])
          format.json { respond_with_bip(@map_objective) }
      else
          format.json { respond_with_bip(@map_objective) }
      end
    end
  end

  def show_resources
    @map_objective = MapObjective.find_by_id_and_user_id params[:id], @current_user.id
    return render nothing: true, status: 404 if !@map_objective

    @map = @map_objective.map
    @resources = Resource.where user_id: @current_user.id
    @filter_resource_types = ResourceType.where( id: @resources.map { |resource| resource.resource_type.id } )
    @filter_course_grades = CourseGrade.where( id: @resources.map { |resource| resource.course_grades.collect(&:id) } )
    @filter_course_subjects = CourseSubject.where( id: @resources.map { |resource| resource.course_subjects.collect(&:id) } )
    @map_resources_by_resource_id = Hash[@map_objective.map_resources.map { |p| [p['resource_id'], p] }]
    
    return render partial: 'map_standards/modal_map_objective_resources'
  end


  def filter_resources

    Rails.logger.info(params)
    @map_objective = MapObjective.find_by_id_and_user_id params[:id], @current_user.id
    return render nothing: true, status: 404 if !@map_objective
    
    @map_resources_by_resource_id = Hash[@map_objective.map_resources.map { |p| [p['resource_id'], p] }]
    
    filter = {}
    @resources = Resource.where( user_id: @current_user.id )

    if params.has_key?('q') and !params[:q].empty?
      @resources &= Resource.where( Resource.arel_table[:title].matches("%#{params[:q].strip}%") )
    end

    if params.has_key?('resource_types')
      @resources &= Resource.find(:all, conditions: {user_id: @current_user.id, resource_type_id: params[:resource_types]})
    end

    if params.has_key?('course_grades')
      @resources &= Resource.find(:all, joins: :course_grades, conditions: {user_id: @current_user.id, course_grades: {id: params[:course_grades]}})
      
    end

    if params.has_key?('course_subjects')
      @resources &= Resource.find(:all, joins: :course_subjects, conditions: {user_id: @current_user.id, course_subjects: {id: params[:course_subjects]}})
    end

    render partial: 'map_standards/table_map_objective_resources'
  end

  def create_resource

      Rails.logger.info(params)
      @map_objective = MapObjective.find_by_id_and_user_id params[:id], @current_user.id
      @resource = Resource.find_by_id_and_user_id params[:resource_id], @current_user.id

      if !@map_objective or !@resource
        Rails.logger.info("error 404 map_objective #{params[:id]} or resource #{params[:resource_id]}") 
        return render nothing: true, status: 404
      end

      @map_standard = @map_objective.map_standard

      if !MapResource.find_by_map_objective_id_and_resource_id(@map_objective, @resource)
        @map_resource = MapObjectiveResource.new
        @map_resource.user = @current_user
        @map_resource.map = @map_objective.map
        @map_resource.resource = @resource
        @map_resource.map_objective = @map_objective
      end

      respond_to do |format|
        if @map_resource.save
          format.html { render partial: 'map_standards/list_map_objectives'}
        else
          Rails.logger.info("error create map_objective_map_resource: #{@map_resource.id}")
          format.html { render json: @map_resource.errors, status: :unprocessable_entity  }
        end
      end
  end

  def destroy_resource
    Rails.logger.info params
    @map_objective = MapObjective.find_by_id_and_user_id params[:id], @current_user.id
    @resource = Resource.find_by_id_and_user_id params[:resource_id], @current_user.id

    if !@map_objective or !@resource
      Rails.logger.info("error 404 map_objective #{params[:id]} or resource #{params[:resource_id]}") 
      return render nothing: true, status: 404
    end

    @map_standard = @map_objective.map_standard
    @map_resource = MapResource.find_by_map_objective_id_and_resource_id  @map_objective.id, @resource.id
    @map_resource.destroy if @map_resource

    respond_to do |format|
      if @map_resource.destroyed?
        format.html { render partial: 'map_standards/list_map_objectives' }
      else
        Rails.logger.info("error delete map_objective_map_resource: #{@map_resource.id}")
        format.html { render json: @map_resource.errors, status: :unprocessable_entity  }
      end
    end
  end


  def sort

    @map_standard = MapStandard.find params[:id]
    return render nothing: true, status: 404 if !@map_standard

    @map_standard.map_objectives.each do |map_objective|
      map_objective.position = params[:new_positions].index(map_objective.id.to_s)+1
      map_objective.save
    end

    render :nothing => true
  end

  private 
  
  # Requires user session
  def require_session
    unless current_user
      redirect_to signin_path
    end
  end
end
