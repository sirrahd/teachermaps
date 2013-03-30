class MapsController < ApplicationController
   include SessionsHelper

  before_filter :require_session

  def show

  	print "Showing map #{params[:id]}"
  	@map = Map.find_by_slug_and_user_id( params[:id], @current_user.id )


    @resources = Resource.where user_id: @current_user.id
    @filter_standard_types = StandardType.all
    @filter_resource_types = ResourceType.all
    @filter_course_grades = CourseGrade.all
    @filter_course_subjects = CourseSubject.all   

  end

  def new
  end

  def destroy
  end

  def ajax_filter_resources

    Rails.logger.info("Filter Params: #{params}")

    filter = {}
    @resources = Resource.where( :user_id => @current_user.id )

    if params.has_key?('q') and !params[:q].empty?
      #@resources &= Resource.where( 'title LIKE ?', "%#{params[:q].strip}%" )
      @resources &= Resource.where( Resource.arel_table[:title].matches("%#{params[:q].strip}%") )
    end

    if params.has_key?('resource_types')
      @resources &= Resource.find(:all, :conditions=>{:user_id => @current_user.id, :resource_type_id=>params[:resource_types]})
    end

    if params.has_key?('course_grades')
      @resources &= Resource.find(:all, :joins => :course_grades, :conditions=>{:user_id => @current_user.id, :course_grades=>{:id => params[:course_grades]}})
      
    end

    if params.has_key?('course_subjects')
      @resources &= Resource.find(:all, :joins => :course_subjects, :conditions=>{:user_id => @current_user.id, :course_subjects=>{:id => params[:course_subjects]}})
    end

    Rails.logger.info(@resources);
    render :partial => 'maps/table_resources'


  end


  def update
  @map = Map.find_by_slug params[:id]

  respond_to do |format|
    if @map.update_attributes(params[:map])
      format.html { redirect_to(@map, :notice => 'Map was successfully updated.') }
      format.json { respond_with_bip(@map) }
    else
      format.html { render :action => "edit" }
      format.json { respond_with_bip(@map) }
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
