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
    Rails.logger.info("Resources = #{@resource}")

    sync_count = 0

    if @current_user.has_google_account?
      google_account = @current_user.google_account 
      Rails.logger.info("Valid Google Session") 
      google_load_session( google_account )
      @files = google_fetch_documents(google_account.folder_id)

      # Create Dictonary {File_ID => Google Resource} to easily check if a file exists
      resources_by_id = Hash[@resources.map { |p| [p['file_id'], p] }]

      Rails.logger.info("Resources by id: #{resources_by_id}")
      @files.each do |file|
       
        if resources_by_id.has_key?(file['id'])
          # Check for name
          #   If not equal update name
          Rails.logger.info("Existing Resource: #{file['id']}")
        else

          Rails.logger.info("Found new Resource: #{file['id']}")
          google_resource = GoogleResource.new
          google_resource.file_id = file['id']
          google_resource.title = file['title']
          google_resource.mime_type = file['mimeType']
          google_resource.file_size = file['fileSize']
          google_resource.save( )

          Rails.logger.info("New Google Resource: #{google_resource.inspect}")
          
          # Add to temp reference dictionary
          resources_by_id[google_resource.file_id] = google_resource
          
          # Add to User
          @current_user.resources << google_resource

          # Increment File Sync Count
          sync_count += 1

        end

      end 

      # Save all new resources
      @current_user.save()

    else
      Rails.logger.info("User does not have a synced Google Account") 
    end


    

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
