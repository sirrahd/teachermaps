require 'google/api_client'
require 'dropbox_sdk'

class ResourcesController < ApplicationController
  include GoogleAccountsHelper
  include DropBoxAccountsHelper
  include SessionsHelper

  before_filter :require_session


  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.where( :user_id => @current_user.id )
    Rails.logger.info("Resources = #{@resource}")


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resources }
    end
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
    @resource = Resource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/new
  # GET /resources/new.json
  def new
    @resource = Resource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/1/edit
  def edit
    @resource = Resource.find(params[:id])
  end

  # POST /resources
  # POST /resources.json
  def create
    @resource = Resource.new(params[:resource])

    respond_to do |format|
      if @resource.save
        format.html { redirect_to @resource, notice: 'Resource was successfully created.' }
        format.json { render json: @resource, status: :created, location: @resource }
      else
        format.html { render action: "new" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /resources/1
  # PUT /resources/1.json
  def update
    @resource = Resource.find(params[:id])

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        format.html { redirect_to @resource, notice: 'Resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to resources_url }
      format.json { head :no_content }
    end
  end

  

  # Sync with Google Drive and/or Dropbox
  def sync
    @resources = Resource.where( :user_id => @current_user.id )
    # @resources = @current_user.resources
    # Rails.logger.info("Resources = #{@resource}")

    sync_count = Hash.new

    if @current_user.has_google_account?
      google_account = @current_user.google_account 
      Rails.logger.info("Valid Google Session") 
      google_load_session( google_account )
      @queryset_resources  = google_fetch_documents(google_account.folder_id)

      # Create Dictonary {File_ID => Google Resource} to easily check if a file exists
      resources_by_id = Hash[@resources.map { |p| [p['file_id'], p] }]
      query_set_ids   = Hash.new


      # Rails.logger.info("Resources by id: #{resources_by_id}")
      @queryset_resources .each do |file|

        
        if file['labels']['trashed'] == true
          # Filters all old and new deletions

          if resources_by_id.has_key?(file['id'])
            # If file has yet to be deleted
            Rails.logger.info("Found Deleted Resource : #{file['title']} ")
            google_resource = resources_by_id[file['id']]
            google_resource.destroy
            sync_count[file['id']] = true

          end


        elsif resources_by_id.has_key?(file['id'])
          
          Rails.logger.info("Found Existing Resource: #{file['id']}")

          # Rename check
          google_resource = resources_by_id[file['id']]
          if file['title'] != google_resource.title
            google_resource.title = file['title']
            google_resource.save
            # Should we update sync_count when renaming files?
            sync_count[file['id']] = true
          end
          
        else

          Rails.logger.info("Found New Resource: #{file['id']}")
          google_resource = GoogleResource.new
          google_resource.file_id = file['id']
          google_resource.title = file['title']
          google_resource.mime_type = file['mimeType']
          google_resource.file_size = file['fileSize']
          google_resource.save( )

          Rails.logger.info("New Google Resource: #{google_resource.inspect}")
          
          # Add to temp reference dictionary, possibly do not need
          resources_by_id[google_resource.file_id] = google_resource
          
          # Add to User
          @current_user.resources << google_resource

          # Increment File Sync Count
          sync_count[file['id']] = true

        end

        # Cache id to later check if TeacherMaps file has been deleted
        query_set_ids[file['id']] = true
      end 






      # # Check for deleted items
      # Rails.logger.info("Query Set Ids: #{query_set_ids.inspect}")

      # @resources.each do |resource|

      #   if resource.class.name != "GoogleResource"
      #     # Do not delete other resources, i.e. DropBox, Custom
      #     next
      #   end

      #   if !query_set_ids.has_key?(resource.file_id)
      #     Rails.logger.info("Deleting #{resource.title}")
      #     # If TeacherMaps has a file which does not exist 
      #     # in the queryset, assume it is has been deleted
      #     # resource.destroy
      #     sync_count[resource['id']] = true
      #   end

      # end 

      # Save all new resources
      @current_user.save()





    else
      Rails.logger.info("User does not have a synced Google Account") 
    end


    

    respond_to do |format|
       format.html { redirect_to resources_url, :flash => { :success => t('resources.synced_n_files', :sync_count => sync_count.length) } }
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
