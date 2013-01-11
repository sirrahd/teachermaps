require 'google/api_client'
# require 'google_api.rb'

class ResourcesController < ApplicationController
  include GoogleAccountsHelper
  include SessionsHelper

  before_filter :require_session


  # GET /resources
  # GET /resources.json
  def index
    # @resources = Resource.all
    @resources = []

    Rails.logger.info("AUTHENTICATED CODE: #{session}")  

    if @current_user.has_google_account?
      google_account = @current_user.google_account 
      Rails.logger.info("Valid Google Session") 
      google_load_session( google_account )
   
      @resources = google_fetch_documents
      Rails.logger.info("GDRIVE FILES: #{google_documents}")  
    else
      Rails.logger.info("User does not have a synced Google Account") 
    end
    
    
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

  ##
  # Google Drive
  ## 
  def google_api_oauth_callback
    
    Rails.logger.info("Callback success")  
    Rails.logger.info("AUTHENTICATED CODE: #{params[:code]}")  

    
    #Save code to user's session
    # session[:auth_code] = params[:code]

    # google_refresh_token( session[:auth_code] )
    google_refresh_token( params[:code] )

    if @current_user.has_google_account?
      google_account = @current_user.google_account 
      Rails.logger.info("Valid Google Session") 
    else
      Rails.logger.info("Invalid Google Session, Creating one") 
      google_account = GoogleAccount.new
      google_account.user_id = @current_user.id
    end
    
    # session[:refresh_token] = google_session.refresh_token
    # session[:access_token]  = google_session.access_token
    # session[:expires_in]    = google_session.expires_in
    # session[:issued_at]     = google_session.issued_at
    
    google_account.refresh_token = google_session.refresh_token
    google_account.access_token = google_session.access_token
    google_account.expires_in = google_session.expires_in
    google_account.issued_at = google_session.issued_at

    google_account.save( )


    respond_to do |format|
      format.html { redirect_to resources_url }
      format.json { head :no_content }
    end
  end 

  def google_drive_sync
  
  
    
    redirect_uri = google_authorization_uri



    Rails.logger.info("REDIRECT_URI: #{redirect_uri}")  
    
    respond_to do |format|
      format.html { redirect_to redirect_uri }
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
