class UsersController < ApplicationController

  def index
    # /users/ was returning a 404
    return_to signin_url if !signed_in?
    redirect_to @current_user
  end

  def show
    # Users must be signed in to view a profile
    redirect_to signin_url if !signed_in?

    @user = User.find_by_account_name params[:id]
    if !@user
      Rails.logger.info 'Could not locate user '
      return render :status => 404
    end

    @maps = Map.where( user_id: @current_user ).order('id DESC')
    @resources = Resource.where( user_id: @current_user.id ).paginate(:page => params[:page], :per_page => 5)
    Rails.logger.info @resources.count

    @filter_course_types = ResourceType.where( id: @resources.map { |resource| resource.resource_type.id } )
    @filter_course_grades = CourseGrade.where( id: @resources.map { |resource| resource.course_grades.collect(&:id) } )
    @filter_course_subjects = CourseSubject.where( id: @resources.map { |resource| resource.course_subjects.collect(&:id) } )

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
    # If the request includes a key, use it
    if params[:key]
      @user = User.find_by_account_name(params[:account_name])
      @user = nil unless @user.request_key == params[:key]

      if @user.update_attributes(params[:user])
        flash[:success] = "Profile updated"
        sign_in @user
        redirect_to @user
      else
        flash[:warning] = t 'reset_password.error'
        redirect_to :back
      end
      return
    end

    # If request is already authenticated
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
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      flash[:warning] = t 'reset_password.error'
      redirect_to :back
    end
  end

  def confirm_email
    @user = User.find_by_account_name(params[:account])

    if @user.request_key == params[:key]
      @user.update_attribute(:confirmed, 1)
      sign_in @user
      flash[:success] = t 'confirmation.success'
      redirect_to @user
    else
      redirect_to signin_url
    end
  end

  def reset_password
    # Stage 3: User navigates from email link
    if params[:account_name]
      @user = User.find_by_account_name(params[:account_name])
      if @user.request_key == params[:key]
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

    # Stage 1: User enters email address
    render 'password_reset_confirmation'
  end

end
