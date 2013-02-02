
class GoogleAccountsController < ApplicationController
  include SessionsHelper

  before_filter :require_session
  

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
      format.html { redirect_to settings_url, :flash => { :notice => t ('google_accounts.already_added') }}
    end

  end



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

    # User denied TeacherMaps access to during OAuth handshake
    if params[:error] == 'access_denied'
      return redirect_to settings_url, :flash => { :notice=> t('google_accounts.denied_oauth')}
    end

    Rails.logger.info("Callback success")  
    Rails.logger.info("AUTHENTICATED CODE: #{params[:code]} \n Client: #{@current_user}")  

    # If user does not have a google account
    if !@current_user.has_google_account?
      Rails.logger.info("Authorized Google Account") 

      google_account = @current_user.google_account    

      # Query Google OAuth tokens
      google_account.fetch_tokens( params[:code] )

      folder_id =  google_account.search_for_teachermaps_folder()

      if folder_id
        Rails.logger.info("Reusing /Apps/TeacherMaps #{folder_id}")
        # Found exisitng /Apps/TeacherMaps folder in GoogleDrive, reusing
        google_account.folder_id = folder_id
        
      else
        # Could not find /Apps/TeacherMaps folder in GoogleDrive
        # Create new /Apps/TeacherMaps folder
        google_account.create_teachermaps_folder()
        Rails.logger.info("Creating new /Apps/TeacherMaps #{google_account.folder_id}")
      end      

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
