class MailChimpController < ApplicationController
  include MailChimpHelper

  def subscribe
    Rails.logger.info params

    return render nothing: true, status: 500 unless params.has_key? 'email'

    if !is_main_production?
      Rails.logger.info 'Subscriptions are only allowed on main production site'
      return render nothing: true, status: 403
    end

    list_id = get_mailing_list()
    
    if subscribe_to_list list_id, params[:email]
      return render nothing: true
    else
      return render nothing: true, status: 500
    end
    
  end

end