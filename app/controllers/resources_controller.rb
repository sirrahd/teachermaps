
class ResourcesController < ApplicationController
  include SessionsHelper

  before_filter :require_session

  def index
    @resources = Resource.where( :user_id => @current_user.id )
    Rails.logger.info("Resources = #{@resource}")

    # For rendering Ajax "Upload Resource" form
    @resource = Resource.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resources }
    end
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
    Rails.logger.info("Resource #{params[:id]}")
    @resource = Resource.find_by_slug( params[:id] )

    if @resource.nil?
      return redirect_to resources_url, :flash => { :error => t('resources.does_not_exist') }
    end

    Rails.logger.info("Showing Resource #{@resource.slug} ")
    
    resource_link = @resource.open_link()

    # Gracefully handle nil links
    if !resource_link
      redirect_to resources_url, :flash => { :error => t('resources.resource_link_error', :title => @resource.title) }
    else
      redirect_to resource_link
    end
    
  end


  def ajax_upload_link
    Rails.logger.info("Using this #{params}")
    @resource = LinkResource.new
    @resource.title = params[:resource][:title]
    @resource.link = params[:resource][:link]

    # Convert primary keys to objects
    if params[:resource].has_key?('course_subjects')
      params[:resource][:course_subjects].each do |subject_id|
        begin
          @resource.course_subjects << CourseSubjects.find(subject_id)
        rescue 
        end
      end
    end
    
    if params[:resource].has_key?('course_grades')
      params[:resource][:course_grades].each do |course_id|
        begin
        @resource.course_grades << CourseGrade.find(course_id)
        rescue 
        end
      end
    end
    
    @type = LinkResource::TYPE

    Rails.logger.info("Creating #{@resource.inspect} valid? #{@resource.valid?}")

    respond_to do |format|

      if @resource.valid? and @resource.save
        @current_user.resources << @resource
        @resources = Resource.where( :user_id => @current_user.id )
        format.js { render :partial => 'resources/resources_table' }
        
      else

        # format.js { render :partial => 'shared/error_messages', :error => true, :status => 500 , :locals => {:object => @resource} }
        format.js { render :partial => 'shared/error_messages', :locals => { :object => @resource }, :status => 500  }
      end

    end

  end  


  def ajax_upload_file
    Rails.logger.info("Using this #{params}")
    @resource = Resource.new()
    @type = Resource::TYPE

    # if params[:resource].has_key?('link')
    #   @resource.link = params[:resource][:link]
    #   @type = LinkResource::TYPE
    # elsif @current_user.setting.has_upload_to?
    #   @type = @current_user.setting.upload_to
    # end

    # if params[:resource]

    # @resource.title = params[:resource][:title]

    # respond_to do |format|

      # if @resource.save
      #   # @current_user.resources << @resource
      #   # @resources = Resource.where( :user_id => @current_user.id )

      #   format.html { render :partial => 'resources/resources_table' }
      #   format.js
      # else

      #   format.html { render :partial => 'resources/error_messages', :error => true, :status => 500  }
      #   format.js
      # end

    # end

    respond_to do |format|
      # if @setting.update_attributes(params[:setting])
      #   Rails.logger.info("Settings save success")
        format.js { render :nothing => true, :status => 200, :content_type => 'text/json' }
      # else
      #   Rails.logger.info("Settings save error")
        # format.html { render :nothing => true, :status => 500, :content_type => 'text/json' }
        # format.js
      # end
    end

  end



  def destroy

    begin
      # Catch resource not found errors
      @resource = Resource.find_by_slug(params[:id])

      # Confirm that the user has permissions to this resource
      Resource.find(:all, :conditions => { :user_id => @current_user.id, :id => params[:id] })
      Rails.logger.info("Found resource")

    rescue
      Rails.logger.info("No such resource")
      return redirect_to resources_url, :flash => { :error =>  t('resources.does_not_exist') }
    end

    # Cache for flash notification
    deleted_title = @resource.title 


    # Google Resource
    if @current_user.has_google_account? and @resource.class.name == "GoogleResource"
      google_account = @current_user.google_account 
      
      Rails.logger.info("Valid Google Session") 

      #google_account.load_session()
      result = google_account.delete_file(@resource.file_id)

      Rails.logger.info("Successful Deletion?: #{result.inspect}")
    else
      Rails.logger.info("User does not have a synced Google Account or File is not a GoogleResource") 
    end



    # DropBox Resources
    if @current_user.has_drop_box_account? and @resource.class.name == "DropBoxResource"
      drop_box_account = @current_user.drop_box_account 

      result = drop_box_account.delete_file(@resource.path)

      Rails.logger.info("Successful Deletion?: #{result}")
      
      Rails.logger.info("Valid DropBox Session") 
    else
      Rails.logger.info("User does not have a synced DropBox Account or File is not a DropBox Resource") 
    end

    # Removing resource
    @resource.destroy


    respond_to do |format|
      format.html { redirect_to resources_url, :flash => { :success => t('resources.deleted_file', :title => deleted_title) } }
      format.json { head :no_content }
    end
  end 

  def sync
    
    sync_count = 0


    # These two can be refactored into two simpler if statements 
    # Google Files
    if @current_user.has_google_account?
      google_account = @current_user.google_account 
      
      Rails.logger.info("Valid Google Session") 

      #google_account.load_session()
      sync_count += google_account.sync_files()
     
    else
      Rails.logger.info("User does not have a synced Google Account") 
    end

    # DropBox Files
    if @current_user.has_drop_box_account?
      drop_box_account = @current_user.drop_box_account 
      
      Rails.logger.info("Valid DropBox Session") 

      #drop_box_account.request_session()
      sync_count += drop_box_account.sync_files()
     
    else
      Rails.logger.info("User does not have a synced DropBox Account") 
    end

    # After all syncing is done, re-query the resources to render
    @resources = Resource.where( :user_id => @current_user.id )
    
    respond_to do |format|
       format.html { redirect_to resources_url, :flash => { :success => t('resources.synced_n_files', :sync_count => sync_count) } }
       format.json { head :no_content }
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
