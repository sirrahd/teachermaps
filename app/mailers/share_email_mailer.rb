class ShareEmailMailer < ActionMailer::Base
  def share_map_email(sender, share_email, map, host)
  	@sender = sender
  	@share_email = share_email
  	@map = map
  	@host = host
    mail( to: share_email.email, subject: "#{@sender.name} sent you a Map!" )
  end
end
