class FeedbacksController < ApplicationController
  def create
    @feedback = Feedback.new( message: params[:feedback][:message],
                              time: Time.now,
                              page: params[:feedback][:page],
                              agent: request.env['HTTP_USER_AGENT'],
                              host: request.env['HTTP_HOST'])

    if params[:anonymous].nil?
      @feedback.name = params[:feedback][:name]
      @feedback.account_name = params[:feedback][:account_name]
      @feedback.email = params[:feedback][:email]
    end

    if @feedback.valid?
      FeedbackMailer.feedback_email(@feedback).deliver
      render json: '', status: :created
    else
      render json: @feedback.errors.full_messages, status: :unprocessable_entity
    end
  end
end
