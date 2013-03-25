class MapStandardsController < ApplicationController
  include SessionsHelper

  before_filter :require_session

  def ajax_new
   
    if !@current_user 
      return render :nothing => true, :status => 403
    end

    print params

    map = Map.find_by_id_and_user_id(params[:map_id], @current_user.id)
    standard = Standard.find(params[:standard_id])

    if !map or !standard
      Rails.logger.info("Could not locate either map #{params[:map_id]} or standard #{params[:standard_id]}") 
      return render :nothing => true, :status => 404
    end

    Rails.logger.info("Located Map #{map} and Standard #{standard}")

    if !MapStandard.find_by_standard_id_and_map_id_and_user_id(standard.id, map.id, @current_user.id)
        new_map_standard = MapStandard.new
        new_map_standard.standard = standard
        new_map_standard.map = map
        new_map_standard.user = @current_user
        map.map_standards << new_map_standard
    end

    # Add any children standards
    standard.children_standards.each do |child_standard|
      # Enforce prevention of the same standard being added twice
      if !MapStandard.find_by_standard_id_and_map_id_and_user_id(child_standard.id, map.id, @current_user.id)
        new_map_standard = MapStandard.new
        new_map_standard.standard = child_standard
        new_map_standard.map = map
        new_map_standard.user = @current_user
        map.map_standards << new_map_standard
      end
    end

    respond_to do |format|
      format.json { render json: '', :status => :ok}
    end
  end

  def ajax_destroy
    if !@current_user 
      return render :nothing => true, :status => 403
    end
    if !params.has_key?('map_id') or !params.has_key?('standard_id')
      return render :nothing => true, :status => 404
    end

    print params

    map = Map.find_by_id_and_user_id(params[:map_id], @current_user.id)
    standard = Standard.find(params[:standard_id])
    map_standard = MapStandard.find_by_standard_id_and_map_id_and_user_id(params[:standard_id], params[:map_id], @current_user.id)

    if !map or !standard or !map_standard
      Rails.logger.info("Could not locate either map standard from given data") 
      return render :nothing => true, :status => 404
    end

    map_standard.destroy

    Rails.logger.info("Deleted map standard")

    respond_to do |format|
      format.json { render json: '', :status => :ok}
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
