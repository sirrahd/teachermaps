
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

    if !@current_user.google_account.owned_by?(@current_user)
      return redirect_to settings_url, flash: {error: 'Invalid Google account'}
    end

    # User denied TeacherMaps access to during OAuth handshake
    if params[:error] == 'access_denied'
      return redirect_to settings_url, :flash => { :notice=> t('google_drive.denied_oauth')}
    end

    @google_account = @current_user.google_account
    # Query Google OAuth tokens
    @google_account.fetch_tokens( params[:code] )

    # Find previous Apps/TeacherMaps folder, else create one
    @google_account.folder_id = @google_account.search_for_teachermaps_folder() || @google_account.create_teachermaps_folder()

    respond_to do |format|
      if @google_account.save
        format.html { redirect_to sync_resources_path }
      else
        Rails.logger.info("Failed Google OAuth Callback #{@google_account.errors}")
        format.html { render nothing: true, status: 500 }
      end
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
