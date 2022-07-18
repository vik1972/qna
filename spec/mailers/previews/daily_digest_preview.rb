# Preview all emails at http://localhost:3000/rails/mailers/daily_digest
class DailyDigestPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/daily_digest/digest
  def digest
    user = User.first
    questions = Question.all.to_a

    DailyDigestMailer.digest(user, questions)
  end

end
