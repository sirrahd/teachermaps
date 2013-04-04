class MapStandardsController < ApplicationController
  include SessionsHelper

  before_filter :require_session
  
  def show
    Rails.logger.info(params)
    @map_standard = MapStandard.find_by_slug params[:id]
  end

  def create

    Rails.logger.info(params)
   
    @map = Map.find_by_id_and_user_id(params[:map_id], @current_user.id)
    @standard = Standard.find(params[:standard_id])

    if !@map or !@standard
      Rails.logger.info("Could not locate either map #{params[:map_id]} or standard #{params[:standard_id]}") 
      return render :nothing => true, :status => 404
    end

    Rails.logger.info("Located Map #{@map} and Standard #{@standard}")

    if !MapStandard.find_by_standard_id_and_map_id_and_user_id(@standard.id, @map.id, @current_user.id)
        @map_standard = MapStandard.new
        @map_standard.standard = @standard
        @map_standard.map = @map
        @map_standard.user = @current_user
        @map_standard.save
        # @map.map_standards << new_map_standard

        # @map.standards_count += 1
        # @map.save
    end

    # Add any children standards
    @standard.children_standards.each do |child_standard|
      # Enforce prevention of the same standard being added twice
      if !MapStandard.find_by_standard_id_and_map_id_and_user_id(child_standard.id, @map.id, @current_user.id)
        @map_standard = MapStandard.new
        @map_standard.standard = child_standard
        @map_standard.map = @map
        @map_standard.user = @current_user
        @map_standard.save
        # @map.map_standards << new_map_standard

        # @map.standards_count += 1
        # @map.save
      end
    end

    return render partial: 'maps/list_map_standards'
  end

  def ajax_destroy
    if !@current_user 
      return render :nothing => true, :status => 403
    end
    if !params.has_key?('map_id') or !params.has_key?('standard_id')
      return render :nothing => true, :status => 404
    end

    @map = Map.find_by_id_and_user_id(params[:map_id], @current_user.id)
    @standard = Standard.find(params[:standard_id])
    map_standard = MapStandard.find_by_standard_id_and_map_id_and_user_id(params[:standard_id], @map.id, @current_user.id)

    if !@map or !@standard or !map_standard
      Rails.logger.info("Could not locate either map standard from given data") 
      return render :nothing => true, :status => 404
    end

    map_standard.destroy

    @map.standards_count -= 1
    @map.objectives_count -= map_standard.map_objectives.count
    @map.save

    Rails.logger.info("Deleted map standard")

    return render partial: 'maps/list_map_standards'
  end


  def destroy

    @map_standard = MapStandard.find( params[:id] )

    if !@map_standard or @map_standard.owned_by?(@current_user)
      Rails.logger.info("Could not locate either map standard from given data") 
      return render :nothing => true, :status => 404
    end

    @map = @map_standard.map
    @map_standard.destroy

    @map.standards_count -= 1
    @map.objectives_count -= @map_standard.map_objectives.count
    @map.save

    respond_to do |format|
      if @map_standard.destroyed?
        Rails.logger.info("Deleted Map Standard")                
        return render partial: 'maps/list_map_standards'
      else
        Rails.logger.info("Map Standard deletion failure!!!")
        format.html { render :json => @map_standard.errors, :status => :unprocessable_entity  }
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
