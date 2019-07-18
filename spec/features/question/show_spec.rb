# frozen_string_literal: true

require 'rails_helper'

feature 'User can view the question and answers to it' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answers) { create_list(:answers, 3, question: question, user: user) }

  scenario 'User can view the question and answers to it' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content 'Answers list'

    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end
