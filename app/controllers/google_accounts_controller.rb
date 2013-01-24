
class GoogleAccountsController < ApplicationController
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
      
      # No account exists, create one
      google_account = GoogleAccount.new

      # Link Google Account to user
      @current_user.google_account = google_account
      @current_user.save()

      # Redirect to Google's OAuth page
      return redirect_to google_account.authorization_url
    end
    
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

           # Delete all google resources belonging to this user
           GoogleResource.delete_all( :type=>'GoogleResource', :user_id=>@current_user.id )

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


    # If user does not have a google account
    if !@current_user.has_google_account?
      Rails.logger.info("Authorized Google Account") 

      google_account = @current_user.google_account    

      # Query Google OAuth tokens
      google_account.fetch_tokens( params[:code] )

      # Create TeacherMaps folder on first sync  
      google_account.create_teachermaps_folder()

      google_account.save( )

    end

    # Sync now
    return redirect_to sync_resources_path

  end

  private 
  
  # Requires user session
  def require_session
    unless current_user
      redirect_to signin_path
    end
  end

end
