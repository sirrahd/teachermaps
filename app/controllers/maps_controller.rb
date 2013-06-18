class MapsController < ApplicationController
   include SessionsHelper

  # before_filter :require_session

  def show

  	@map = Map.find_by_slug params[:id]
  	# Single variable that determines the permissions state
  	# throughout the html templates
  	@is_admin = (signed_in? and @map.is_admin?(@current_user))
  	# Rails.logger.info "IS ADMIN? #{@is_admin}"

  	unless @map
      Rails.logger.info("error 404 map #{params[:id]}") 
      return redirect_to page404_url
    end

    # Allows contributor and owner to see the page no matte what
    # Returns 404 if the page is set to private
  	if not @is_admin and @map.privacy_state == PrivacyState::PRIVATE
  		Rails.logger.info("error 404 map #{params[:id]}") 
  		return redirect_to page404_url
  	end

    # Used for rendering standards filter
    @filter_standard_types = StandardType.all
    @filter_resource_types = ResourceType.all
    @filter_course_grades = CourseGrade.all
    # Currently only have CCSS ELA and Math
    @filter_course_subjects = CourseSubject.where name: ['English', 'Mathematics']

  end

  def create
  	require_session
    Rails.logger.info(params)

    @map = Map.new user_id: @current_user.id
    @is_admin = (signed_in? and @map.is_admin?(@current_user))
    
    respond_to do |format|
      if @map.save
        # @maps = @current_user.maps
        if @is_admin
		    	@maps = @current_user.maps
		    else
		    	@maps = @current_user.public_maps
		    end
        format.html { render partial: 'users/table_maps'}
      else
        Rails.logger.info("error create map #{@map.errors.inspect}")
        format.html { render json: @map.errors, status: :unprocessable_entity  }
      end
    end
  end

  def destroy
  	require_session
    Rails.logger.info(params)
    
    @map = Map.find_by_id params[:id]
    @is_admin = (signed_in? and @map.is_admin?(@current_user))
    @map.destroy if @map
  
    respond_to do |format|
      if @map.destroyed?
        # @maps = @current_user.maps
        if @is_admin
		    	@maps = @current_user.maps
		    else
		    	@maps = @current_user.public_maps
		    end
        format.html { render partial: 'users/table_maps'}
      else
        Rails.logger.info("error delete map #{@map.errors.inspect}")
        format.html { render json: @map.errors, status: :unprocessable_entity  }
      end 
    end
  end


  def update
  	Rails.logger.info params
  	require_session
    @map = Map.find_by_id_and_user_id params[:id], @current_user.id
    unless @map
      Rails.logger.info("error 404 map #{params[:id]}") 
      return render nothing: true, status: 404
    end
    @is_admin = (signed_in? and @map.is_admin?(@current_user))

    respond_to do |format|
      if @map.update_attributes(params[:map])
        format.json { respond_with_bip(@map) }
      else
        format.json { respond_with_bip(@map) }
      end
    end
  end

  def sort_assessments
		require_session
    @map = Map.find params[:map_id]
    return render nothing: true, status: 404 unless @map
    @is_admin = (signed_in? and @map.is_admin?(@current_user))

    @map.map_assessments.each do |map_assessment|
      map_assessment.position = params[:map_assessment].index(map_assessment.id.to_s)+1
      map_assessment.save
    end

    render :nothing => true
  end

  def sort_standards
  	require_session
    @map = Map.find params[:map_id]
    return render nothing: true, status: 404 unless @map
    @is_admin = (signed_in? and @map.is_admin?(@current_user))

    @map.map_standards.each do |map_standard|
      map_standard.position = params[:map_standard].index(map_standard.id.to_s)+1
      map_standard.save
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
