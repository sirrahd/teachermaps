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

    # Get the DropboxClient object.  Redirect to OAuth flow if necessary.
    db_client = get_db_client
    Rails.logger.info("DropBox Rails Client #{db_client} Session: #{session[:authorized_db_session]}")  
    # unless db_client
    #     redirect url("/oauth-start")
    # end

    # Call DropboxClient.metadata
    path =  '/'
    begin
        #entry = db_client.metadata(path)
        entry = db_client.metadata(path)
    rescue DropboxAuthError => e
        session.delete(:authorized_db_session)  # An auth error means the db_session is probably bad
        # return html_page "Dropbox auth error", "<p>#{h e}</p>"
    rescue DropboxError => e
        # if e.http_response.code == '404'
        #     return html_page "Path not found: #{h path}", ""
        # else
        #     return html_page "Dropbox API error", "<pre>#{h e.http_response}</pre>"
        # end
        Rails.logger.info("DropBox Error")  
    end

    if entry['is_dir']
        entries = render_folder(db_client, entry)
    else
        entries = render_file(db_client, entry)
    end

    Rails.logger.info("DropBox Entries: #{entries}")  


    


    
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

    google_refresh_token( params[:code] )

    if @current_user.has_google_account?
      google_account = @current_user.google_account 
      Rails.logger.info("Valid Google Session") 
    else
      Rails.logger.info("Invalid Google Session, Creating one") 
      google_account = GoogleAccount.new
      google_account.user_id = @current_user.id
    end

    google_account.refresh_token = google_session.refresh_token
    google_account.access_token  = google_session.access_token
    google_account.expires_in    = google_session.expires_in
    google_account.issued_at     = google_session.issued_at

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
