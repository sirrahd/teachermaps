class MailChimpController < ApplicationController
  include MailChimpHelper

  def subscribe
    Rails.logger.info params
    return render nothing: true
  end

end