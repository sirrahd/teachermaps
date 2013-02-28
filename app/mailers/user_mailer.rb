class UserMailer < ActionMailer::Base

  def welcome_email(user)
    @user = user
    @url = user.email_confirmation_url
    mail( to: user.email, subject: t('welcome_email.subject') )
  end
end
