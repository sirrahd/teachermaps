class UsersController < ApplicationController
	include SessionsHelper

  def index
    redirect_to root_url
  end

  def show
    # Users must be signed in to view a profile
    # redirect_to signin_url if !signed_in?

    @user = User.find_by_account_name params[:id]
    unless @user
      Rails.logger.info 'Could not locate user '
      return redirect_to page404_url
    end
    @progress = @user.show_progress
    @maps = Map.where( user_id: @current_user ).order('id DESC')
    @resources = @current_user.resources.paginate(page: params[:page]).order('id DESC')

    @is_admin = (signed_in? and @user.is_admin?(@current_user))
  	# Rails.logger.info "IS ADMIN? #{@is_admin}"

    if @is_admin
    	@maps = @user.maps
    else
    	@maps = @user.public_maps
    end

    @resources = @user.resources.paginate(page: params[:page]).order('id DESC')
    @num_of_pages = @user.total_resources_count / 20 + 2

    @filter_course_types = ResourceType.where( id: @user.resources.collect { |resource| resource.resource_type.id } )
    @filter_course_grades = CourseGrade.where( id: @user.resources.collect { |resource| resource.course_grades.collect(&:id) } )
    @filter_course_subjects = CourseSubject.where( id: @user.resources.collect { |resource| resource.course_subjects.collect(&:id) } )

    # For rendering Ajax "Upload Resource" form
    @resource = Resource.new

  end

  def new
    redirect_to @current_user if signed_in?
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      UserMailer.welcome_email(@user, request.env['HTTP_HOST']).deliver
      flash[:success] = t('signup.welcome', app_name: t('global.app_name'))
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  	require_session
    # User is always authenticated before an update
    @user = current_user

    # If user's email changes unconfirm them and send a confirmation email
    if params[:user] and params[:user][:email]
     unless params[:user][:email] == @user.email
        @user.email = params[:user][:email]
        if @user.save
          @user.update_attribute(:confirmed, 0)
          UserMailer.change_email(@user, request.env['HTTP_HOST']).deliver
          sign_in @user
        end
      end
    end

    # Update any other attributes
    if @user.update_attributes(params[:user])
      flash[:success] = t 'settings.profile_updated'
      sign_in @user #updates invalidate current sign in
      flash[:user_info] = @user
      redirect_to settings_path
    else
      flash[:user_info] = @user
      redirect_to settings_path
    end
  end

  def update_password
    if params.has_key?(:account_name) # Used if user forgot password
      @key = params[:key]
      account = User.find_by_account_name(params[:account_name])
      @user = account if account.request_key == @key
    else
      @user = current_user
    end

    if params.has_key?(:current_password)
      if !@user.authenticate(params[:current_password])
        @user.errors.add :Password, "isn't correct."
        render 'password_reset'
        return
      end
    end

    # Password can't be blank, but I can't seem to use validations for
    # this without causing any updates that DON'T include a password
    # to fail, so we'll check it here.
    # Note: Passwords are never made blank, but erroneously show success.
    if params[:user][:password] == ""
      @user.errors.add :Password, "can't be blank."
      render 'password_reset'
      return
    end

    if @user.update_attributes(params[:user])
      flash[:success] = t 'settings.profile_updated'
      sign_in @user
      redirect_to @user
    else
      render 'password_reset'
    end
  end

  def confirm_email
  	require_session
    @user = current_user

    # If there's no logged in user, take them to the login form first
    unless @user
      @key = params[:key]
      flash[:warning] = t 'confirmation.login'
      render 'sessions/new'
      return
    end

    if @user.request_key == params[:key]
      @user.update_attribute(:confirmed, 1)
      sign_in @user
      flash[:success] = t 'confirmation.success'
      redirect_to @user
    elsif params[:resend]
      UserMailer.change_email(@user, request.env['HTTP_HOST']).deliver
    else
      flash[:error] = t 'confirmation.error'
      redirect_to @user
    end
  end

  def reset_password
  	require_session
    # Stage 3: User navigates from email link
    if params[:account_name]
      @user = User.find_by_account_name(params[:account_name])
      if @user.request_key == params[:key]
        @key = params[:key]
        render 'password_reset'
        return
      else
        flash[:warning] = t 'reset_password.error'
      end

    #Stage 2: User provides email address
    elsif params[:email]
      if @user = User.find_by_email(params[:email])
        UserMailer.reset_password_email(@user, request.env['HTTP_HOST']).deliver
        flash[:success] = t 'reset_password.email_sent'
        redirect_to root_url
        return
      else
          # Fails, re-render reset confirmation with the flash
          flash[:warning] = t 'reset_password.error'
      end
    end

    # User is already signed in
    if current_user
      @user = current_user
      render 'password_reset'
      return
    end

    # Stage 1: User enters email address
    render 'password_reset_confirmation'
  end

  private

  # Requires user session
  def require_session
    unless current_user
      redirect_to signin_path
    end
  end

end
