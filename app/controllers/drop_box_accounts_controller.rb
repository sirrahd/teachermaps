require 'dropbox_sdk'

class DropBoxAccountsController < ApplicationController
include DropBoxAccountsHelper

  APP_KEY    = Rails.application.config.APP_KEY
  APP_SECRET = Rails.application.config.APP_SECRET

  # GET /drop_box_accounts
  # GET /drop_box_accounts.json
  def index
    @drop_box_accounts = DropBoxAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @drop_box_accounts }
    end
  end

  # GET /drop_box_accounts/1
  # GET /drop_box_accounts/1.json
  def show
    @drop_box_account = DropBoxAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @drop_box_account }
    end
  end


  # GET /drop_box_accounts/1
  # GET /drop_box_accounts/1.json
  def download
    #@drop_box_account = DropBoxAccount.find(params[:])
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
        entry = db_client.shares( "/#{params[:path]}" )
        #entry = db_client.shares( '/gemspec.rb' )
    rescue DropboxAuthError => e
        session.delete(:authorized_db_session)  # An auth error means the db_session is probably bad
        # return html_page "Dropbox auth error", "<p>#{h e}</p>"
    rescue DropboxError => e
        Rails.logger.info("DropBox Error")  
    end

    Rails.logger.info("DropBox Sharable: #{entry}")  

    return redirect_to entry['url']
    # respond_to do |format|
    # format.html # show.html.erb
    # format.json { render json: @drop_box_account }
    # end
  end

  # GET /drop_box_accounts/new
  # GET /drop_box_accounts/new.json
  def new
    #@drop_box_account = DropBoxAccount.new

    # respond_to do |format|
    #   format.html # new.html.erb
    #   format.json { render json: @drop_box_account }
    # end

    db_session = DropboxSession.new(APP_KEY, APP_SECRET)
    begin
        db_session.get_request_token
    rescue DropboxError => e
       Rails.logger.info("Oh..no.. DropBox session request broke")   
    end

    session[:request_db_session] = db_session.serialize

    auth_url = db_session.get_authorize_url 'http://localhost:3000/dropbox/oauth_callback'
    
    redirect_to auth_url
  end

  
  def oauth_callback
    
    # Finish OAuth Step 2
    ser = session[:request_db_session]
    unless ser
        return html_page "Error in OAuth step 2", "<p>Couldn't find OAuth state in session.</p>"
    end
    db_session = DropboxSession.deserialize(ser)

    # OAuth Step 3: Get an access token from Dropbox.
    begin
        db_session.get_access_token
    rescue DropboxError => e
        Rails.logger.info("Oh..no.. DropBox second step broke.")   
        return redirect_to root_path
    end
    session.delete(:request_db_session)
    session[:authorized_db_session] = db_session.serialize
  
    # In this simple example, we store the authorized DropboxSession in the web
    # session hash.  A "real" webapp might store it somewhere more persistent.
    
    redirect_to resources_url
  end


  # GET /drop_box_accounts/1/edit
  def edit
    @drop_box_account = DropBoxAccount.find(params[:id])
  end

  # POST /drop_box_accounts
  # POST /drop_box_accounts.json
  def create
    @drop_box_account = DropBoxAccount.new(params[:drop_box_account])

    respond_to do |format|
      if @drop_box_account.save
        format.html { redirect_to @drop_box_account, notice: 'Drop box account was successfully created.' }
        format.json { render json: @drop_box_account, status: :created, location: @drop_box_account }
      else
        format.html { render action: "new" }
        format.json { render json: @drop_box_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /drop_box_accounts/1
  # PUT /drop_box_accounts/1.json
  def update
    @drop_box_account = DropBoxAccount.find(params[:id])

    respond_to do |format|
      if @drop_box_account.update_attributes(params[:drop_box_account])
        format.html { redirect_to @drop_box_account, notice: 'Drop box account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @drop_box_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drop_box_accounts/1
  # DELETE /drop_box_accounts/1.json
  def destroy
    @drop_box_account = DropBoxAccount.find(params[:id])
    @drop_box_account.destroy

    respond_to do |format|
      format.html { redirect_to drop_box_accounts_url }
      format.json { head :no_content }
    end
  end
end
