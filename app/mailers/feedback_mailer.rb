class FeedbackMailer < ActionMailer::Base

  def feedback_email(feedback)
    @feedback = feedback
    mail( subject:"You've got feedback!",
          to: Rails.application.config.FEEDBACK_ADDRESSES )
  end
end
