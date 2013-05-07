class StandardsController < ApplicationController
  include SessionsHelper

  before_filter :require_session

  def ajax_filter
    Rails.logger.info(params)

    unless params.has_key?('standard_type') and params.has_key?('course_subject')
      Rails.logger.info("Dude, you forgot the standard type or course subject #{params[:course_subject]} #{params[:standard_type]}")
      return render partial: 'standards/list'
    end

    @map = Map.find(params[:map_id])
    @standards = Standard.find(:all, conditions: {standard_type_id: params[:standard_type], parent_standard_id: nil})

    if params.has_key?('course_subject')
      @standards &= Standard.find(:all, conditions: {course_subject_id: params[:course_subject]})
    end
  
    if params.has_key?('course_grades')
      @standards &= Standard.find(:all, joins: :course_grades, conditions: {course_grades: {id: params[:course_grades]}})
    end

    if params.has_key?('q') and !params[:q].empty?
      #@standards &= Standard.where("lower(text) LIKE ?", "%#{params[:q].strip.downcase}%")
      @standards &= Standard.where( Standard.arel_table[:text].matches("%#{params[:q].strip}%") )
    end
    
    if @current_user
      @map_standards = MapStandard.where(user_id: @current_user.id, map_id: params[:map_id])
      @map_standards_by_standard_id = Hash[@map_standards.map { |p| [p['standard_id'], p] }]
    end
    
    render partial:  'maps/list_standards'
  end

  private 
  
  # Requires user session
  def require_session
    unless current_user
      redirect_to signin_path
    end
  end
end
