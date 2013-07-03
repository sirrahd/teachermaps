
class ResourcesController < ApplicationController
  include SessionsHelper

  # before_filter :require_session

  def index
    # Currently does not exist
    redirect_to @current_user
  end

  def show
  	require_session
    Rails.logger.info(params)
    @resource = Resource.find_by_id_and_user_id params[:id], @current_user.id
    unless @resource
      return redirect_to resources_url, flash:  { error: t('resources.does_not_exist') }
    end

    resource_link = @resource.open_link()

    # Gracefully handle nil links
    if !resource_link
      redirect_to @current_user, :flash => { :error => t('resources.resource_link_error', :title => @resource.title) }
    else
      redirect_to resource_link
    end
    
  end

  def edit
  	require_session
    @resource = Resource.find_by_id_and_user_id params[:id], @current_user.id
    return render nothing: true, status: 404 unless @resource
    render partial: "resources/edit"
  end

  def update
  	require_session
    Rails.logger.info(params)
    @resource = Resource.find_by_id_and_user_id params[:id], @current_user.id
    return render nothing: true, status: 404 unless @resource

    @resource.title = params[:resource][:title]

    if @resource.class.name == LinkResource::TYPE
      @resource.link = params[:resource][:link]
    end

    # Convert grade/subject primary keys to objects
    if params[:resource].has_key?('course_subjects')
      @resource.course_subjects = params[:resource][:course_subjects].present? ? CourseSubject.find_all_by_id(params[:resource][:course_subjects]) : []
      else
      @resource.course_subjects = []
    end
    
    if params[:resource].has_key?('course_grades')
      @resource.course_grades = params[:resource][:course_grades].present? ? CourseGrade.find_all_by_id(params[:resource][:course_grades]) : []
    else
      @resource.course_grades = []
    end

    respond_to do |format|
      if @resource.save
        #@resources = Resource.where user_id: @current_user.id

        # @current_user.update_attributes resources: Resource.where( user_id: @current_user.id )
        # @current_user = User.find @current_user.id
        @resources = @current_user.resources
        format.html { render partial:  'resources/table_resources' }

      else
        format.html { render partial:  'shared/error_messages', :locals => { :object => @resource }, :status => 500  }
      end
    end
  end


  def destroy
  	require_session

    @resource = Resource.find_by_id_and_user_id params[:id], @current_user.id

    unless @resource
      Rails.logger.info("404 Error, Resource not found #{@resource.errors.inspect}")
      return redirect_to resources_url, :flash => { :error =>  t('resources.does_not_exist') }
    end
    
    # Cache for flash notification
    deleted_title = @resource.title 

    # Google Resource
    if @current_user.has_google_account? and @resource.class.name == GoogleResource::TYPE
      google_account = @current_user.google_account 
      
      Rails.logger.info("Valid Google Session") 

      result = google_account.delete_file(@resource.file_id)

      Rails.logger.info("Successful Deletion?: #{result.inspect}")
    else
      Rails.logger.info("User does not have a synced Google Account or File is not a GoogleResource") 
    end

    # DropBox Resources
    if @current_user.has_drop_box_account? and @resource.class.name == DropBoxResource::TYPE
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
      if @resource.destroyed?            
        format.html { redirect_to user_path(@current_user, anchor: 'resources'), :flash => { :success => t('resources.deleted_file', :title => deleted_title) } }
      else
        Rails.logger.info("Resource deletion failure!!! #{@resource.errors.inspect}")
        format.html { render json: @resource.errors, status: :unprocessable_entity  }
      end 
    end

  end 

  def filter
  	require_session
    Rails.logger.info(params)

    filter = {}
    #@resources = Resource.where user_id: @current_user.id
    @resources = @current_user.resources

    if params.has_key?('q') and !params[:q].empty?
      @resources &= Resource.where( Resource.arel_table[:title].matches("%#{params[:q].strip}%") )
    end

    if params.has_key?('resource_types')
      @resources &= Resource.find(:all, conditions: {user_id: @current_user.id, resource_type_id: params[:resource_types]})
    end

    if params.has_key?('course_grades')
      @resources &= Resource.find(:all, joins:  :course_grades, conditions: {user_id: @current_user.id, course_grades: {id: params[:course_grades]}})
      
    end

    if params.has_key?('course_subjects')
      @resources &= Resource.find(:all, joins: :course_subjects, conditions: { user_id: @current_user.id, course_subjects: { id:params[:course_subjects]}})
    end

    sleep(1.0)
    render partial:  'resources/table_resources'

  end

  def create_link
  	require_session
    Rails.logger.info(params)

    @resource = LinkResource.new
    @resource.user = @current_user
    @resource.title = params[:resource][:title]
    @resource.link = params[:resource][:link]
    @resource.resource_type = ResourceType.find_by_name('Web')

    # Convert primary keys to objects
    if params[:resource].has_key?('course_subjects')
      @resource.course_subjects = params[:resource][:course_subjects].present? ? CourseSubject.find_all_by_id(params[:resource][:course_subjects]) : []
    end
    
    if params[:resource].has_key?('course_grades')
      @resource.course_grades = params[:resource][:course_grades].present? ? CourseGrade.find_all_by_id(params[:resource][:course_grades]) : []
    end  
    
    @type = LinkResource::TYPE

    respond_to do |format|

      if @resource.save
        #@resources = Resource.where user_id: @current_user.id
        @resources = @current_user.resources
        format.html { render partial:  'resources/table_resources' }

      else
        format.js { render partial:  'shared/error_messages', :locals => { :object => @resource }, :status => 500  }
      end

    end

  end  

  def sync
  	require_session
    
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
    #@resources = Resource.where user_id: @current_user.id
    @resources = @current_user.resources

    respond_to do |format|
       format.html { redirect_to user_path(@current_user, anchor: 'resources'), :flash => { :success => t('resources.synced_n_files', :sync_count => sync_count) } }
    end
  end


  def page
  	require_session

    @resources = @current_user.resources.paginate(page: params[:page])
    render partial: 'resources/table_resources'
  end 


  private

  # Requires user session
  def require_session
    unless current_user
      redirect_to signin_path
    end
  end
end
