class UsersController < ApplicationController

  def index
    # /users/ was returning a 404
    return_to signin_url if !signed_in?
    redirect_to @current_user
  end

  def show
    # Users must be signed in to view a profile
    redirect_to signin_url if !signed_in?

    # Users can only sign in to their own account; ignore params
    @user = @current_user

    @resources = Resource.where( user_id: @current_user.id )

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

  def show_with_email_confirmation
    @user = User.find_by_account_name(params[:account])

    if @user.email_confirmation_key == params[:key]
      @user.update_attribute(:confirmed, 1)
      sign_in @user
      flash[:success] = t 'confirmation.success'
      redirect_to @user
    else
      redirect_to signin_url
    end
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
end
