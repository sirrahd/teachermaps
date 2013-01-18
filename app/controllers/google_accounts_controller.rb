require 'google/api_client'

class GoogleAccountsController < ApplicationController
  include GoogleAccountsHelper
  include SessionsHelper

  before_filter :require_session
  

  # GET /google_accounts
  # GET /google_accounts.json
  def index
    @google_accounts = GoogleAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @google_accounts }
    end
  end

  # GET /google_accounts/1
  # GET /google_accounts/1.json
  def show
    @google_account = GoogleAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @google_account }
    end
  end

  # GET /google_accounts/new
  # GET /google_accounts/new.json
  def new


    if !@current_user.has_google_account?
      #google_account = @current_user.google_account 
      Rails.logger.info("Valid Google Session") 
      return redirect_to google_authorization_uri
    end
    

    Rails.logger.info("Current User: #{@current_user}")  
    Rails.logger.info("REDIRECT_URI: #{settings_url}")  
    
    respond_to do |format|
      format.html { redirect_to settings_url, :flash => { :notice => "Google Drive already added." }}
    end
  end

  def oauth_callback

    Rails.logger.info("Callback success")  
    Rails.logger.info("AUTHENTICATED CODE: #{params[:code]} \n Client: #{@current_user}")  

    google_refresh_token( params[:code] )

    if @current_user.has_google_account?
      google_account = @current_user.google_account 
      Rails.logger.info("Valid Google Session") 
    else
      Rails.logger.info("Invalid Google Session, Creating one") 
      google_account = GoogleAccount.new
      google_account.user_id = @current_user.id
    end

    app_folder = create_folder("Apps", "Store and Organize all your teaching materials");
    Rails.logger.info("Apps Folder: #{app_folder['mimeType']}")
    teachermaps_folder = create_folder("TeacherMaps", "Store and Organize all your teaching materials", app_folder['id']);
    Rails.logger.info("TeacherMaps Folder: #{teachermaps_folder['mimeType']}")
    google_account.folder_id       = teachermaps_folder['id']

    google_account.refresh_token = google_session.refresh_token
    google_account.access_token  = google_session.access_token
    google_account.expires_in    = google_session.expires_in
    google_account.issued_at     = google_session.issued_at

    google_account.save( )


    respond_to do |format|
      format.html { redirect_to resources_url, :flash => { :success => "Synced with Google Drive" } }
      format.json { head :no_content }
    end

  end

  # GET /google_accounts/1/edit
  def edit
    @google_account = GoogleAccount.find(params[:id])
  end

  # POST /google_accounts
  # POST /google_accounts.json
  def create
    @google_account = GoogleAccount.new(params[:google_account])

    respond_to do |format|
      if @google_account.save
        format.html { redirect_to @google_account, notice: 'Google account was successfully created.' }
        format.json { render json: @google_account, status: :created, location: @google_account }
      else
        format.html { render action: "new" }
        format.json { render json: @google_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /google_accounts/1
  # PUT /google_accounts/1.json
  def update
    @google_account = GoogleAccount.find(params[:id])

    respond_to do |format|
      if @google_account.update_attributes(params[:google_account])
        format.html { redirect_to @google_account, notice: 'Google account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @google_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /google_accounts/1
  # DELETE /google_accounts/1.json
  def destroy
    @google_account = GoogleAccount.find(params[:id])
    @google_account.destroy

    if @current_user.has_google_account?
      @current_user.google_account = nil
      @current_user.save( )
      Rails.logger.info("Removed Google Drive Reference") 
    end

    respond_to do |format|
      format.html { redirect_to settings_url, :flash => { :success => "Removed Google Drive" }}
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
