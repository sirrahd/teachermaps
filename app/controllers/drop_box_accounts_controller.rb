
class DropBoxAccountsController < ApplicationController
  include SessionsHelper

  before_filter :require_session

  def new

    if !@current_user.has_drop_box_account?
      @current_user.drop_box_account = DropBoxAccount.new
      @current_user.save()

      # Request an Authorized Session
      session_data = @current_user.drop_box_account.fetch_request()

      return respond_to do |format|
        if session_data
          # Successful request, redirecting...
          session[:request_db_session] = session_data[:request_db_session]
          format.html { redirect_to session_data[:auth_url] }
        else
          # Unsuccessfull request
          format.html { redirect_to settings_path, :flash => { :error => t('drop_box.session_request_error') } }
        end
      end   
    end

    return respond_to do |format|
      format.html { redirect_to settings_url, :flash => { :notice => I18n.t('google_drive.already_added') }}
    end

  end

  
  def oauth_callback

    # User denied TeacherMaps access to during OAuth handshake
    if params[:not_approved] == 'true'
      return redirect_to settings_url, :flash => { :notice=> t('drop_box.denied_oauth')}
    end

    # Get user's DropBox account
    drop_box_account = @current_user.drop_box_account
    # Load Session via authenticated access code
    drop_box_account.fetch_tokens(session[:request_db_session])
    
    # Clean up session
    session.delete(:request_db_session)

    # Redirect to first sync
    redirect_to sync_resources_path
  end


  def destroy
    @drop_box_account = DropBoxAccount.find(params[:id])
    @setting = Setting.find(@current_user.id)

    if !@drop_box_account.owned_by?(@current_user)
      return redirect_to settings_url, flash: {error: 'Invalid Dropbox account'}
    end

    if !@current_user.has_drop_box_account?
      # User does not have a dropbox account
      return redirect_to settings_url, flash: {error: 'User does not have a Dropbox account'}
    end 

    @current_user.drop_box_account = nil
    @current_user.save( )
    @drop_box_account.destroy

    # Remove all resources reference to DropBox resources belonging to this user
    DropBoxResource.destroy_all( type: DropBoxResource::TYPE, user_id: @current_user.id  )

    if @current_user.has_google_account?
      # Transfer default uploads to Google
      @setting.upload_to = GoogleResource::TYPE
    else
      # User is going to need to assign one before next upload
      @setting.upload_to = nil
    end

    respond_to do |format|
      if @drop_box_account.destroyed? and @setting.save()
        format.html { redirect_to settings_url, flash: { success: t('drop_box.removed')}}
      else
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
