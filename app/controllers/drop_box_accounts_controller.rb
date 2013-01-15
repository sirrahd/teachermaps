require 'dropbox_sdk'

class DropBoxAccountsController < ApplicationController
include DropBoxAccountsHelper
include SessionsHelper

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
  def preview
    #@drop_box_account = DropBoxAccount.find(params[:])
    # Get the DropboxClient object.  Redirect to OAuth flow if necessary.
    db_client = get_db_client
    Rails.logger.info("DropBox Rails Client #{db_client}")  
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
        # redirect to dropbox ouath
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


    # Check for existing dropbox account
    # If dropbox account and has permission (authorized)
    #    redirect to sync page
    # end

    drop_box_session = request_drop_box_session()

    if drop_box_session.has_key('request_db_session') and !drop_box_session['request_db_session'].nil?
       session[:request_db_session] = drop_box_session['request_db_session']
    end
    
    if drop_box_session.has_key('auth_url') and !drop_box_session['auth_url'].nil?
       redirect_to drop_box_session['auth_url']
    else
       redirect_to settings_path
    end

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

    Rails.logger.info("CurrentUser#{current_user}")

    if (@current_user.has_drop_box_account?)
      @current_user.drop_box_account.session_token = db_session.serialize
    else
      @current_user.drop_box_account = DropBoxAccount.new( {"user_id" => @current_user.id, "session_token" => db_session.serialize} )
    end 

    @current_user.save()
    
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
