class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  default_scope { order(best: :desc).order(created_at: :asc) }

  def mark_best!
    transaction do
      self.class.where(question_id: question_id).update(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end
