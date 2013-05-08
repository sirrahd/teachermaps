class MailChimpController < ApplicationController
  include MailChimpHelper
  include ApplicationHelper

  def subscribe
    Rails.logger.info params

    return render nothing: true, status: 500 unless params.has_key? 'email'

    if !is_main_proudction?
      Rails.logger.warn 'Subscriptions are only allowed on main production site, did not complete subscription.'
      return render nothing: true
    end

    list_id = get_mailing_list()

    if list_id and subscribe_to_list list_id, params[:email]
      return render nothing: true
    else
      return render nothing: true, status: 500
    end
    
  end

end