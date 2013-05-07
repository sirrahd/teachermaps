module ApplicationHelper

  def is_main_proudction?
    Rails.application.config.respond_to? 'PRODUCTION_DOMAIN' and Rails.application.config.PRODUCTION_DOMAIN.include? request.host_with_port 
  end
  
end
