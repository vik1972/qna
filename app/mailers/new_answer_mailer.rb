class NewAnswerMailer < ApplicationMailer
  def new_notification(user, new_answer)
    @answer = new_answer
    @question = new_answer.question

    mail to: user.email
  end
end
