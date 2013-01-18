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
      # No account exists
      # Redirect to Google's OAuth page
      return redirect_to google_authorization_uri
    end
    
    # Found previous Google Account, notify user
    respond_to do |format|
      format.html { redirect_to settings_url, :flash => { :notice => "Google Drive already added." }}
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
    
     flash = {}
     if @current_user.has_google_account?
        account = @current_user.google_account 

        if account.id == @google_account.id 
           # If user owns requested Google Account

           @current_user.google_account = nil
           @current_user.save( )

           @google_account.destroy

           flash['success'] = t('google_accounts.removed')
        else 
           flash['notice'] = t('google_accounts.remove_invalid')
        end

    end

    respond_to do |format|
      format.html { redirect_to settings_url, :flash => flash }
      format.json { head :no_content }
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
      # Creating new account for User
      google_account = GoogleAccount.new
      google_account.user_id = @current_user.id
    end

    google_account.folder_id = google_create_teachermaps_folder()
    
    google_account.refresh_token = google_session.refresh_token
    google_account.access_token  = google_session.access_token
    google_account.expires_in    = google_session.expires_in
    google_account.issued_at     = google_session.issued_at

    google_account.save( )


    respond_to do |format|
      format.html { redirect_to resources_url, :flash => { :success => t('google_accounts.success_sync') } }
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
