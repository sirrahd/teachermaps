class MapStandardsController < ApplicationController
  include SessionsHelper

  before_filter :require_session
  
  def show
    Rails.logger.info(params)
    @map_standard = MapStandard.find_by_slug params[:id]
  end

  def create

    Rails.logger.info(params)
   
    @map = Map.find_by_id_and_user_id params[:map_id], @current_user.id
    @standard = Standard.find params[:standard_id]

    if !@map or !@standard
      Rails.logger.info("error 404 map #{params[:map_id]} or standard #{params[:standard_id]}") 
      return render nothing: true, status: 404
    end

    if !MapStandard.find_by_standard_id_and_map_id @standard.id, @map.id
      @map_standard = MapStandard.new
      @map_standard.standard = @standard
      @map_standard.map = @map
      @map_standard.user = @current_user
      @map_standard.save

      if !@map_standard.save
        Rails.logger.info("500 error map_standard") 
        return render json: @map_standard.errors, status: :unprocessable_entity
      end
    end

    # Add any children standards
    @standard.children_standards.each do |child_standard|
      # Enforce prevention of the same standard being added twice
      if !MapStandard.find_by_standard_id_and_map_id child_standard.id, @map.id
        @map_standard = MapStandard.new
        @map_standard.standard = child_standard
        @map_standard.map = @map
        @map_standard.user = @current_user
      
        if !@map_standard.save
          Rails.logger.info("500 error map_standard") 
          return render json: @map_standard.errors, status: :unprocessable_entity
        end
      end
    end

    return render partial: 'maps/list_map_standards'
  end

  def destroy
    Rails.logger.info(params)
    
    @map_standard = MapStandard.find_by_id_and_user_id params[:id], @current_user.id

    if !@map_standard
      Rails.logger.info("404 error map_standard #{params[:id]}") 
      return render nothing: true, status: 404
    end

    @map = @map_standard.map
    @map_standard.destroy

    respond_to do |format|
      if @map_standard.destroyed?       
        return render partial: 'maps/list_map_standards'
      else
        Rails.logger.info("500 error delete map_standard #{@map_standard.errors.inspect}")
        format.html { render json: @map_standard.errors, status: :unprocessable_entity  }
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
