require 'google/api_client'
require 'google_api.rb'

class ResourcesController < ApplicationController



  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.all

    
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
    session[:google_drive_code] = params[:code]

    client = GoogleApi.new
    @files = client.fetch_documents( session[:google_drive_code] )
    Rails.logger.info("GDRIVE FILES: #{client.documents}")  

    respond_to do |format|
      format.html { redirect_to resources_url }
      format.json { head :no_content }
    end
  end 

  def google_drive_sync
  
  
    client = GoogleApi.new
    redirect_uri = client.authorization_uri



    Rails.logger.info("REDIRECT_URI: #{redirect_uri}")  
    
    respond_to do |format|
      format.html { redirect_to redirect_uri }
    end
  end
end
