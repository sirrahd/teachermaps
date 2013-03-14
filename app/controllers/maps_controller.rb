class MapsController < ApplicationController
   include SessionsHelper

  before_filter :require_session


  def show

  	print "Showing map #{params[:id]}"
  	@map = Map.find_by_slug_and_user_id( params[:id], @current_user.id )

  end

  

  def new

    # if !@current_user.has_google_account?
      
    #   # No account exists, create one
    #   google_account = GoogleAccount.new

    #   # Link Google Account to user
    #   @current_user.google_account = google_account
    #   @current_user.save()

    #   # Redirect to Google's OAuth page
    #   return redirect_to google_account.authorization_url
    # end
    
    # respond_to do |format|
    #   format.html { redirect_to settings_url, :flash => { :notice => I18n.t('google_drive.already_added') }}
    # end

    #return render , :locals => { :object => @resource }, :status => 500


  end



  def destroy
    #  @google_account = GoogleAccount.find(params[:id])
    #  @setting = Setting.find(@current_user.id)

    
    #  flash = {}
    #  if @current_user.has_google_account?
    #     account = @current_user.google_account 

    #     if account.id == @google_account.id 
    #        # If user owns requested Google Account

    #        @current_user.google_account = nil
    #        @current_user.save( )

    #        @google_account.destroy

    #        # Delete all google resources belonging to this user
    #        GoogleResource.delete_all( :type=>GoogleResource::TYPE, :user_id=>@current_user.id )

    #        flash['success'] = t('google_drive.removed')


    #        if @current_user.has_drop_box_account?
    #           # Transfer default uploads to DropBox
    #           @setting.upload_to = GoogleResource::TYPE
    #        else
    #           # User is going to need to assign one before next upload
    #           @setting.upload_to = nil
    #        end
    #        @setting.save()

    #     else 
    #        flash['notice'] = t('google_drive.remove_invalid')
    #     end

    # end

    # respond_to do |format|
    #   format.html { redirect_to settings_url, :flash => flash }
    #   format.json { head :no_content }
    # end
  end


  private 
  
  # Requires user session
  def require_session
    unless current_user
      redirect_to signin_path
    end
  end
end
