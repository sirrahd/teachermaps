class UsersController < ApplicationController

  def index
    # /users/ was returning a 404
    return_to signin_url if !signed_in?
    redirect_to @current_user
  end

  def show
    # Users must be signed in to view a profile
    return_to signin_url if !signed_in?

    # Users can only sign in to their own account; ignore params
    @user = @current_user

    @resources = Resource.where( :user_id => @current_user.id )

    @filter_course_grades = CourseGrade.where(:id => @resources.map { |resource| resource.course_grades.collect(&:id) } )
    @filter_course_subjects = CourseSubject.where(:id => @resources.map { |resource| resource.course_subjects.collect(&:id) } )
  

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
      flash[:success] = t('signup.welcome', app_name: t('global.app_name'))
      redirect_to @user
    else
      render 'new'
    end
  end
end
