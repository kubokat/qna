# frozen_string_literal: true

require 'rails_helper'

feature 'Author can delete his answer' do
  given(:author_user) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author_user) }
  given!(:answer) { create(:answer, question: question, user: author_user) }

  describe 'Authenticated user' do
    scenario 'deletes his answer',js: true do
      sign_in(author_user)
      visit question_path(question)

      within '.answers' do
        click_on 'Delete'
      end

      expect(page).to_not have_content answer.body
    end

    scenario "deletes someone else's answer",js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to deletes an answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end
