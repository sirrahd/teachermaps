class FeedbacksController < ApplicationController
  def create
    @feedback = Feedback.new( message: params[:feedback][:message],
                              time: Time.now,
                              page: params[:feedback][:page],
                              agent: request.env['HTTP_USER_AGENT'],
                              host: request.env['HTTP_HOST'])

    if @feedback.valid?
      FeedbackMailer.feedback_email(@feedback).deliver
      render json: '', status: :created
    else
      render json: @feedback.errors.full_messages, status: :unprocessable_entity
    end
  end
end
