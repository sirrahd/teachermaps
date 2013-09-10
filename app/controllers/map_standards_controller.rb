class MapStandardsController < ApplicationController
  include SessionsHelper
  include HtmlHelper
  
  def show
    Rails.logger.info(params)
    @map_standard = MapStandard.find_by_slug params[:id]
    @map = @map_standard.map
    @is_admin = (signed_in? and @map_standard.map.is_admin?(@current_user))
    @share_email = ShareEmail.new
 	
  	if not @is_admin and @map.privacy_state == PrivacyState::PRIVATE
  		Rails.logger.info("error 404 map #{params[:id]}") 
  		return redirect_to page404_url
  	end
  end

  def create
  	require_session

    Rails.logger.info(params)
   
    @map = Map.find_by_id_and_user_id params[:map_id], @current_user.id
    @standard = Standard.find params[:standard_id]

    unless @map and @standard
      Rails.logger.info("error 404 map #{params[:map_id]} or standard #{params[:standard_id]}") 
      return render nothing: true, status: 404
    end

    if !MapStandard.find_by_standard_id_and_map_id @standard.id, @map.id
      @map_standard = MapStandard.new
      @map_standard.standard = @standard
      @map_standard.map = @map
      @map_standard.user = @current_user
      @map_standard.position = @standard.id
      @map_standard.save

      @map.course_grades << @standard.course_grades
      @map.course_subjects << @standard.course_subject

      unless @map_standard.save
        Rails.logger.info("error create map_standard") 
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

        @map.course_grades << child_standard.course_grades
        @map.course_subjects << child_standard.course_subject
      
        unless @map_standard.save
          Rails.logger.info("error create map_standard") 
          return render json: @map_standard.errors, status: :unprocessable_entity
        end
      end
    end

    @is_admin = (signed_in? and @map_standard.map.is_admin?(@current_user))
    return render partial: 'maps/list_map_standards'
  end

  def destroy
  	require_session
    Rails.logger.info(params)
    
    @map_standard = MapStandard.find_by_id_and_user_id params[:id], @current_user.id
    @is_admin = (signed_in? and @map_standard.map.is_admin?(@current_user))

    unless @map_standard
      Rails.logger.info("error 404 map_standard #{params[:id]}") 
      return render nothing: true, status: 404
    end

    @map = @map_standard.map

    # Delete metadata
    @map.course_grades -= @map_standard.standard.course_grades
    @map.course_subjects -= [@map_standard.standard.course_subject]
    @map_standard.destroy

    # Update metadata
    @map.update_metadata

    respond_to do |format|
      if @map_standard.destroyed?       
        return render partial: 'maps/list_map_standards'
      else
        Rails.logger.info("error delete map_standard #{@map_standard.errors.inspect}")
        format.html { render json: @map_standard.errors, status: :unprocessable_entity  }
      end 
    end
  end

  def sort_objectives
  	require_session

    @map_standard = MapStandard.find params[:map_standard_id]
    return render nothing: true, status: 404 unless @map_standard

    @map_standard.map_objectives.each do |map_objective|
      map_objective.position = params[:map_objective].index(map_objective.id.to_s)+1
      map_objective.save
    end

    render nothing: true
  end

  private 
  
  # Requires user session
  def require_session
    unless current_user
      redirect_to signin_path
    end
  end
end
