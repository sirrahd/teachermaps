class StandardsController < ApplicationController
  include SessionsHelper

  before_filter :require_session

  def show
    Rails.logger.info("Standards")
  end

  def ajax_filter
    print params
    Rails.logger.info("Filter Params: #{params}")

    if !params.has_key?('standard_type') or !params.has_key?('course_subject')
      Rails.logger.info("Dude, you forgot the standard type or course subject #{params[:course_subject]} #{params[:standard_type]}")
      return render :partial => 'standards/list'
    end

    @standards = Standard.find(:all, :conditions=>{:standard_type_id=>params[:standard_type], :parent_standard_id=>nil})

    if params.has_key?('course_subject')
      @standards &= Standard.find(:all, :conditions=>{:course_subject_id=>params[:course_subject]})
    end
  
    if params.has_key?('course_grades')
      @standards &= Standard.find(:all, :joins => :course_grades, :conditions=>{:course_grades=>{:id => params[:course_grades]}})
    end

    if params.has_key?('q') and !params[:q].empty?
      #@standards &= Standard.where( Standard.arel_table[:text].matches("%#{params[:q].strip}%") )
      @standards &= Standard.find(:all, :conditions => ['text LIKE ?', "%#{params[:q].strip}%"])
    end
    
    if @current_user
      map_standards = MapStandard.where(user_id: @current_user.id, map_id: params[:map_id])
      @map_standards_by_standard_id = Hash[map_standards.map { |p| [p['standard_id'], p] }]
      # Rails.logger.info("Map Standards: #{@map_standards_by_standard_id.inspect}")
    end

    # Rails.logger.info(@standards);
    render :partial => 'standards/list'
  end

  private 
  
  # Requires user session
  def require_session
    unless current_user
      redirect_to signin_path
    end
  end
end
