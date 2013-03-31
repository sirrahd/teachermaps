class MapsController < ApplicationController
   include SessionsHelper

  before_filter :require_session

  def show

  	print "Showing map #{params[:id]}"
  	@map = Map.find_by_slug_and_user_id( params[:id], @current_user.id )


    @resources = Resource.where user_id: @current_user.id
    @filter_standard_types = StandardType.all
    @filter_resource_types = ResourceType.all
    @filter_course_grades = CourseGrade.all
    @filter_course_subjects = CourseSubject.all   

  end

  def create
      Rails.logger.info(params)
      @map = Map.new()
      @map.user = @current_user


      respond_to do |format|
        if @map.save
          @maps = Map.order("created_at DESC")
          Rails.logger.info("#{current_user.account_name} created a new map #{@maps}")
          format.html { render :partial => 'users/table_maps', :locals => { :object => @map } }
        else
          Rails.logger.info("Map creation failure!!!")
          format.html { render :json => @map.errors, :status => :unprocessable_entity  }
        end
      end
  end

  def destroy
  end

  


  def update
    @map = Map.find_by_slug params[:id]

    respond_to do |format|
      if @map.update_attributes(params[:map])
        format.html { redirect_to(@map, :notice => 'Map was successfully updated.') }
        format.json { respond_with_bip(@map) }
      else
        format.html { render :action => "edit" }
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
