require 'google/api_client'
require 'google_api.rb'

class ResourcesController < ApplicationController



  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.all

   
    client = GoogleApi.new.get_client
    drive = client.discovered_api('drive', 'v2')
    # plus = client.discovered_api('plus')

    Rails.logger.info("INDEX - GOOGLE API CODE: #{session[:google_drive_code]}")  
    client.authorization.code = session[:google_drive_code]
    client.authorization.fetch_access_token!

    result = Array.new
    page_token = nil
    
    api_result = client.execute(
      :api_method => drive.files.list
    )
    if api_result.status == 200
      files = api_result.data
      result.concat(files.items)
    else

      Rails.logger.info("An error occurred pulling data from Google API HTTP Error #{api_result.status}")
      page_token = nil
    end

    Rails.logger.info("GDRIVE FILES: #{api_result.data} #{result}")  
    
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
  def google_drive_oauth_callback
    
    Rails.logger.info("Callback success")  
    Rails.logger.info("AUTHENTICATED CODE: #{params[:code]}")  

    # Rails.logger.info("Access Token: #{client.authorization.access_token}")
    # client.authorization.fetch_access_token
    # Rails.logger.info("Access Token: #{client.authorization.access_token}")

    session[:google_drive_code] = params[:code]
    #Rails.logger.info("REDIRECT_URI: #{client}")  
    #Rails.logger.info("REDIRECT_URI: #{client.authorization.authorization_uri.to_s}")  


    respond_to do |format|
      format.html { redirect_to resources_url }
      format.json { head :no_content }
    end
  end 

  def google_drive_sync

    # @resources = Resource.all
    
    client = GoogleApi.new.get_client
    drive = client.discovered_api('drive')

    # # Initialize OAuth 2.0 client    
    # client.authorization.client_id = Rails.application.config.CLIENT_ID
    # client.authorization.client_secret = Rails.application.config.CLIENT_SECRET
    # client.authorization.redirect_uri = Rails.application.config.REDIRECT_URI
    # client.authorization.scope = Rails.application.config.SCOPES
    
    # authorization_uri is not an string, need to convert
    redirect_uri = client.authorization.authorization_uri.to_s

    Rails.logger.info("REDIRECT_URI: #{redirect_uri}")  
    
    respond_to do |format|
      format.html { redirect_to redirect_uri }
    end
  end
end
