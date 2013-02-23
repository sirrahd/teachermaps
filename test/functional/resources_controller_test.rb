# class ResourcesControllerTest < ActionController::TestCase
#   test 'Inalid feedback should should not send' do
#     post :create, feedback: {time: "time", page: "page", agent: "agent", host: "host", message: ""}
#     #email = FeedbackMailer.feedback_email(feedback).deliver
#     assert ActionMailer::Base.deliveries.empty?
#   end

#   test 'Valid feedback should should send' do
#     post :create, feedback: {time: "time", page: "page", agent: "agent", host: "host", message: "message"}
#     #email = FeedbackMailer.feedback_email(feedback).deliver
#     assert !ActionMailer::Base.deliveries.empty?
#   end
# end
