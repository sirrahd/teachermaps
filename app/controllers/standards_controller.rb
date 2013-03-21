class StandardsController < ApplicationController
  include SessionsHelper

  before_filter :require_session

  def show
    Rails.logger.info("Standards")
  end

  def new
  end 

  def destroy
  end

  def ajax_filter
    print params
    render :partial => 'standards/table'
  end

  private 
  
  # Requires user session
  def require_session
    unless current_user
      redirect_to signin_path
    end
  end
end
