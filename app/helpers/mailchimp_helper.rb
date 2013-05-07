module MailchimpHelper


  def get_mailing_list

    @mailchimp = Gibbon.new
    # Rails.logger.info @mailchimp.lists
    # Rails.logger.info 'MailChimp'

    # Rails.logger.info @list['data']
    @mailchimp.lists['data'].each do |list|
      #Rails.logger.info "ListID: #{list['id']} Name: #{list['name']} isTrue? #{list['name'] == 'TeacherMaps Mailing List'}"
      if list['name'] == 'TeacherMaps Mailing List'
        return list['id']
      end
    end

    false
  end

  def subscribe_to_list( list_id, email_address )
    Rails.logger.info "Subscribing #{email_address} to mailing list #{list_id}"
    @mailchimp = Gibbon.new
    @val = @mailchimp.list_subscribe({
        id: list_id, 
        email_address: email_address,
        update_existing: true, 
        double_optin: false,
        merge_vars: {}
    })
    Rails.logger.info "Completed Subscription #{@val}"
  end





end