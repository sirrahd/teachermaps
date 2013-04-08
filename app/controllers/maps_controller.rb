class MapsController < ApplicationController
   include SessionsHelper

  before_filter :require_session

  def show

  	@map = Map.find_by_slug_and_user_id( params[:id], @current_user.id )

    # Used for rendering standards filter
    @filter_standard_types = StandardType.all
    @filter_resource_types = ResourceType.all
    @filter_course_grades = CourseGrade.all
    @filter_course_subjects = CourseSubject.all   

  end

  def create
    Rails.logger.info(params)

    @map = Map.new user_id: @current_user.id
    
    respond_to do |format|
      if @map.save
        @maps = @current_user.maps
        format.html { render :partial => 'users/table_maps'}
      else
        Rails.logger.info("Map creation failure!!! #{@map.errors.inspect}")
        format.html { render :json => @map.errors, :status => :unprocessable_entity  }
      end
    end
  end

  def destroy
    Rails.logger.info(params)
    
    @map = Map.find_by_id_and_user_id params[:id], @current_user.id
    @map.destroy if @map
  
    respond_to do |format|
      if @map.destroyed?
        @maps = @current_user.maps
        format.html { render :partial => 'users/table_maps'}
      else
        Rails.logger.info("Map deletion failure!!! #{@map.errors.inspect}")
        format.html { render :json => @map.errors, :status => :unprocessable_entity  }
      end 
    end
  end


  def update
    @map = Map.find_by_id_and_user_id params[:id], @current_user.id

    respond_to do |format|
      if @map.update_attributes(params[:map])
        format.json { respond_with_bip(@map) }
      else
        format.json { respond_with_bip(@map) }
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
