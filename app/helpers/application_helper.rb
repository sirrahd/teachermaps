module ApplicationHelper

  def is_main_proudction?
    Rails.application.config.respond_to? 'PRODUCTION_DOMAINS' and Rails.application.config.PRODUCTION_DOMAINS.include? request.host_with_port 
  end
  
end
