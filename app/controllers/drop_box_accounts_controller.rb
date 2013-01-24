
class DropBoxAccountsController < ApplicationController

  include SessionsHelper

  before_filter :require_session


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

    drop_box_account = nil

    if @current_user.has_drop_box_account?
      # Reuse DropBox Account
      drop_box_account = @current_user.drop_box_account
    else
      # Create new DropBox account
      drop_box_account = DropBoxAccount.new
      @current_user.drop_box_account = drop_box_account
      @current_user.save()
    end

    # Request an Authorized Session
    session_data = drop_box_account.fetch_request()

    if session_data != false
      # Successful request, redirecting...
      session[:request_db_session] = session_data[:request_db_session]
      redirect_to session_data[:auth_url]
    else
      # Unsuccessfull request
      redirect_to settings_path, :flash => { :error => t('drop_box.session_request_error') }
    end
    
  end

  
  def oauth_callback

    # Get user's DropBox account
    drop_box_account = @current_user.drop_box_account
    # Load Session via authenticated access code
    drop_box_account.fetch_tokens(session[:request_db_session])
    
    # Clean up session
    session.delete(:request_db_session)

    # Redirect to first sync
    redirect_to sync_resources_path
  end


  # GET /drop_box_accounts/1/edit
  def edit
    @drop_box_account = DropBoxAccount.find(params[:id])
  end

  # DELETE /drop_box_accounts/1
  # DELETE /drop_box_accounts/1.json
  def destroy
 

    @drop_box_account = DropBoxAccount.find(params[:id])
    
     flash = {}
     if @current_user.has_drop_box_account?
        account = @current_user.drop_box_account 

        if account.id == @drop_box_account.id
           # If user owns requested DropBox Account

           @current_user.drop_box_account = nil
           @current_user.save( )

           @drop_box_account.destroy

           # Remove all resources reference to DropBox resources belonging to this user
           DropBoxResource.delete_all( :type =>'DropBoxResource', :user_id=>@current_user.id  )

           flash['success'] = t('drop_box_acounts.removed')
        else 
           flash['notice'] = t('drop_box_acounts.remove_invalid')
        end

    end

    respond_to do |format|
      format.html { redirect_to settings_url, :flash => flash }
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
