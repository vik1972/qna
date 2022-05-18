class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true

  has_many_attached :files

  default_scope { order(best: :desc).order(created_at: :asc) }

  def mark_best!
    transaction do
      self.class.where(question_id: self.question_id).update(best: false)
      update(best: true)
    end
  end
end
