class ShareEmailMailer < ActionMailer::Base
  def share_map_email(user, to_email)
    @user = user
    mail( to: to_email, subject: "#{user.name} sent you a map!" )
  end
end
