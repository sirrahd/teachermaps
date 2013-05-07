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





end