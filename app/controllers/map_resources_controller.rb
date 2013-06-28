class MapResourcesController < ApplicationController
	include SessionsHelper

	# before_filter :require_session


	def show
    Rails.logger.info(params)
    # @resource = Resource.find_by_id_and_user_id params[:id], @current_user.id
    @map_resource = MapResource.find_by_id params[:id]
    @resource = @map_resource.resource
    @map = @map_resource.map
    unless @map_resource
      # return redirect_to resources_url, flash:  { error: t('resources.does_not_exist') }
      return redirect_to page404_url
    end

    @is_admin = (signed_in? and @map.is_admin?(@current_user))
  	if not @is_admin and @map.privacy_state == PrivacyState::PRIVATE
  		Rails.logger.info("error 404 map #{params[:id]}") 
  		return redirect_to page404_url
  	end

    resource_link = @resource.open_link()

    # Gracefully handle nil links
    if !resource_link
      redirect_to @current_user, :flash => { :error => t('resources.resource_link_error', :title => @resource.title) }
    else
      redirect_to resource_link
    end
    
  end


	def update
		require_session
		@map_resource = MapResource.find_by_id_and_user_id params[:id], @current_user.id
    return render nothing: true, status: 404 unless @map_resource

  	respond_to do |format|
    	if @map_resource.update_attributes params[:map_resource] and @map_resource.save
      	format.json { respond_with_bip @map_resource  }
	    else
	      format.json { respond_with_bip @map_resource }
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
