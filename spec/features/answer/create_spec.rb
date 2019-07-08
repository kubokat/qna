# frozen_string_literal: true

require 'rails_helper'

feature 'User can write answer for the question', '
  The user, being on the question page, can write an answer to the question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'write an answer' do
      fill_in 'Body', with: 'Answer Body Text'
      click_on 'Create Answer'

      expect(page).to have_content 'Your answer succesfully created.'
      expect(page).to have_content 'Answer Body Text'
    end

    scenario 'write an answer with errors' do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to write an answer' do
    visit question_path(question)
    fill_in 'Body', with: 'Answer Body Text'
    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
