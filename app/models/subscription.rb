class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates_presence_of :question
  validates_presence_of :user
end
