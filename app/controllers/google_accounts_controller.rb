
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
      format.html { redirect_to settings_url, :flash => { :notice => I18n.t('google_drive.already_added') }}
    end

  end

  def destroy
    @google_account = GoogleAccount.find(params[:id])
    @setting = Setting.find(@current_user.id)

    if !@google_account.owned_by?(@current_user)
      return redirect_to settings_url, flash: {error: 'Invalid Google account'}
    end

    if !@current_user.has_google_account?
      # User does not have a dropbox account
      return redirect_to settings_url, flash: {error: 'User does not have a Google account'}
    end 

    @current_user.google_account = nil
    @current_user.save( )

    @google_account.destroy

    # Delete all google resources belonging to this user
    GoogleResource.destroy_all( :type=>GoogleResource::TYPE, :user_id=>@current_user.id )

    if @current_user.has_drop_box_account?
      # Transfer default uploads to DropBox
      @setting.upload_to = DropBoxResource::TYPE
    else
      # User is going to need to assign one before next upload
      @setting.upload_to = nil
    end
    @setting.save()

    respond_to do |format|
      if @google_account.destroyed? and @setting.save()
        format.html { redirect_to settings_url, flash: { success: t('google_drive.removed')}}
      else
        format.html { render nothing: true, status: 500 }
      end
    end

  end


  def oauth_callback

  

    # User denied TeacherMaps access to during OAuth handshake
    if params[:error] == 'access_denied'
      return redirect_to settings_url, :flash => { :notice=> t('google_drive.denied_oauth')}
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
