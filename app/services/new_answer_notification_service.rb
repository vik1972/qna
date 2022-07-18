class NewAnswerNotificationService
  def send_notification(new_answer)
    new_answer.question.subscriptions.find_each do |subscription|
      NewAnswerMailer.new_notification(subscription.user, new_answer).deliver_later
    end
  end
end