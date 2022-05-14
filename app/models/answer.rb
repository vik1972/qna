class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true

  default_scope { order(best: :desc).order(created_at: :asc) }

  def mark_best!
    transaction do
      # question.answers.lock!.update_all(best: false)
      self.class.where(question_id: self.question_id).update(best: false)
      update(best: true)
    end
  end
end
