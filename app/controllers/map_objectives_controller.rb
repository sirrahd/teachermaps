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


  private 
  
  # Requires user session
  def require_session
    unless current_user
      redirect_to signin_path
    end
  end
end
