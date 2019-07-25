# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true
  default_scope { order(best: :desc) }

  def set_best
    Answer.where(question_id: self.question_id).update(best: false)
    update(best: true)
  end
end
