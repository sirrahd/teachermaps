class UserMailer < ActionMailer::Base

  def welcome_email(user, host)
    @user = user
    @host = host
    mail( to: user.email, subject: t('welcome_email.subject') )
  end

  def reset_password_email(user, host)
    @user = user
    @host = host
    mail( to: user.email, subject: t('reset_password.subject') )
  end
end
