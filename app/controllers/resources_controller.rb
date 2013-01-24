require 'dropbox_sdk'

class ResourcesController < ApplicationController
  include DropBoxAccountsHelper
  include SessionsHelper

  before_filter :require_session


  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.where( :user_id => @current_user.id )
    Rails.logger.info("Resources = #{@resource}")

    # Temporary, just testing out search_for_teachermaps_folder()
    # if @current_user.has_google_account?

    #   @current_user.google_account.search_for_teachermaps_folder()
    # end


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
    Rails.logger.info("Showing Resource #{@resource.slug} ")
    
    resource_link = @resource.open_link()

    # Gracefully handle broken links
    if !resource_link
      redirect_to resources_url, :flash => { :error => t('resources.resource_link_error', :title => @resource.title) }
    else
      redirect_to resource_link
    end
    
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource = Resource.find(params[:id])

    deleted_title = @resource.title 

    Rails.logger.info("Deleting a #{@resource.class.name}")

    @resource = Resource.find(params[:id])

    result = Resource.find(:all, :conditions => { :user_id => @current_user.id, :id => params[:id] })

    if result.nil?
      Rails.logger.info("No such resource")
      return redirect_to resources_url, :flash => { :error => 'Resouce does not exist' }
    else
      Rails.logger.info("Found resource")
    end

    # Google Resource
    if @current_user.has_google_account? and @resource.class.name == "GoogleResource"
      google_account = @current_user.google_account 
      
      Rails.logger.info("Valid Google Session") 

      google_account.load_session()
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

    # Google Files
    if @current_user.has_google_account?
      google_account = @current_user.google_account 
      
      Rails.logger.info("Valid Google Session") 

      google_account.load_session()
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
