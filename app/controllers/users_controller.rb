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

    @test = CourseGrade.where(:id => @resources.map { |resource| resource.course_grades.collect(&:id) } )
    blah = @resources.map { |resource| resource.course_grades.collect(&:id)}
    @next = @test.map {|x| [x.id, x.name]}
    Rails.logger.info("Filtered Grades #{blah}")
    Rails.logger.info("Filtered Grades #{@test.inspect}")
    Rails.logger.info("Filtered Grades #{@next.inspect}")


    @filter_course_grades = {}
    @resources.each do |resource|
      if !resource.course_grades.empty?
        resource.course_grades.each do |x|
          @filter_course_grades[x.id] = x.name
        end 
      end
    end
    # Rails.logger.info("Filtered Grades #{@filter_course_grades}")



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
