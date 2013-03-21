class MapsController < ApplicationController
   include SessionsHelper

  before_filter :require_session

  def show

  	print "Showing map #{params[:id]}"
  	@map = Map.find_by_slug_and_user_id( params[:id], @current_user.id )

    @filter_course_grades = CourseGrade.all
    @filter_course_subjects = CourseSubject.all
    @filter_standard_types = StandardType.all

  end

  def new
  end

  def destroy
  end

  private 
  
  # Requires user session
  def require_session
    unless current_user
      redirect_to signin_path
    end
  end
end
