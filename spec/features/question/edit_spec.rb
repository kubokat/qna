require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do
    given!(:user2) { create(:user) }

    scenario 'edits his question', js: true do
      sign_in user
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: 'Updated title Test question'
        fill_in 'Body', with: 'Updated body text'
        click_on 'Edit'

        expect(page).to have_content 'Updated title Test question'
      end

      within '.content' do
        expect(page).to_not have_content question.body
        expect(page).to have_content 'Updated body text'
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in user
      visit question_path(question)

      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Edit'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question", js: true do
      sign_in user2
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link('Edit')
      end

    end
  end
end