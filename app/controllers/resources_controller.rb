
class ResourcesController < ApplicationController
  include SessionsHelper

  before_filter :require_session

  def index
    # Currently does not exist
    redirect_to @current_user
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
      redirect_to @current_user, :flash => { :error => t('resources.resource_link_error', :title => @resource.title) }
    else
      redirect_to resource_link
    end
    
  end

  def ajax_show 
    Rails.logger.info("Resource #{params[:slug]}")
    @resource = Resource.find_by_slug( params[:slug] )

    Rails.logger.info("Showing Resource #{@resource.slug} ")

    Rails.logger.info("Resource Link: #{@resource.link}")

    respond_to do |format|
    # Gracefully handle nil links
      if @resource.nil?
        format.html { render :partial => 'shared/error_messages', :locals => { :object => @resource }, :status => 500  }
      else
        format.html { render :partial => 'resources/show'}
      end
    end
    
  end


    # GET /resources/1/edit
  def edit
    @resource = Resource.where(:id => params[:id], :user_id=>@current_user.id).first
    Rails.logger.info("Editing #{@resource.inspect}")
    render partial: "resources/edit"
  end

  # PUT /resrouce/1
  # PUT /resource/1.json
  def update
    Rails.logger.info("Updating Resource #{params}")
    @resource = Resource.where(:id => params[:id], :user_id=>@current_user.id).first

    @resource.title = params[:resource][:title]

    if @resource.class.name == LinkResource::TYPE
      @resource.link = params[:resource][:link]
    end

    # Convert primary keys to objects
    if params[:resource].has_key?('course_subjects')
      @resource.course_subjects = params[:resource][:course_subjects].present? ? CourseSubject.find_all_by_id(params[:resource][:course_subjects]) : []
      else
      # User deleted all course subjects
      @resource.course_subjects = []
    end
    
    if params[:resource].has_key?('course_grades')
      @resource.course_grades = params[:resource][:course_grades].present? ? CourseGrade.find_all_by_id(params[:resource][:course_grades]) : []
    else
      # User deleted all course grades
      @resource.course_grades = []
    end

    respond_to do |format|
      if @resource.valid? and @resource.save
        @resources = Resource.where( :user_id => @current_user.id )
        format.html { render :partial => 'resources/table_resources' }
      else
        #format.html { render partial: "resources/edit", :errors => '' }
        format.html { render :partial => 'shared/error_messages', :locals => { :object => @resource }, :status => 500  }
        #format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def ajax_filter

    Rails.logger.info("Filter Params: #{params}")

    filter = {}
    @resources = Resource.where( :user_id => @current_user.id )

    if params.has_key?('q') and !params[:q].empty?
      #@resources &= Resource.where( 'title LIKE ?', "%#{params[:q].strip}%" )
      @resources &= Resource.where( Resource.arel_table[:title].matches("%#{params[:q].strip}%") )
    end

    if params.has_key?('resource_types')
      @resources &= Resource.find(:all, :conditions=>{:user_id => @current_user.id, :resource_type_id=>params[:resource_types]})
    end

    if params.has_key?('course_grades')
      @resources &= Resource.find(:all, :joins => :course_grades, :conditions=>{:user_id => @current_user.id, :course_grades=>{:id => params[:course_grades]}})
      
    end

    if params.has_key?('course_subjects')
      @resources &= Resource.find(:all, :joins => :course_subjects, :conditions=>{:user_id => @current_user.id, :course_subjects=>{:id => params[:course_subjects]}})
    end

    Rails.logger.info(@resources);
    render :partial => 'resources/table_resources'


  end

  def ajax_upload_link
    Rails.logger.info("Using this #{params}")
    @resource = LinkResource.new
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

    Rails.logger.info("Creating #{@resource.inspect} valid? #{@resource.valid?}")

    respond_to do |format|

      if @resource.valid? and @resource.save
        @current_user.resources << @resource
        @resources = Resource.where( :user_id => @current_user.id )

        # Need to re-generate filters
        @filter_course_types = ResourceType.where(:id => @resources.map { |resource| resource.resource_type.id } )
        @filter_course_grades = CourseGrade.where(:id => @resources.map { |resource| resource.course_grades.collect(&:id) } )
        @filter_course_subjects = CourseSubject.where(:id => @resources.map { |resource| resource.course_subjects.collect(&:id) } )
        # Render filter and resources to dictionary
        response = { 
          :filters => render_to_string(:partial => 'resources/form_filter_resources', :layout => false,  :locals => {:resources => @resources, :filter_course_types => @filter_course_types, :filter_course_grades=>@filter_course_grades, :filter_course_subjects=>@filter_course_subjects}),
          :resources => render_to_string(:partial => 'resources/table_resources', :layout => false,  :locals => {:resources => @resources})
        }
        # Send resource and fitlers back via JSON format
        format.js { render :json => response }
        
      else
        format.js { render :partial => 'shared/error_messages', :locals => { :object => @resource }, :status => 500  }
      end

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
      format.html { redirect_to @current_user, :flash => { :success => t('resources.deleted_file', :title => deleted_title) } }
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
       format.html { redirect_to @current_user, :flash => { :success => t('resources.synced_n_files', :sync_count => sync_count) } }
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
