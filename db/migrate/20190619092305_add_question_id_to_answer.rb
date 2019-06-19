class AddQuestionIdToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :answers, :questions
  end
end
