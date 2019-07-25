require 'rails_helper'

feature 'User can choose best answer' do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'choose the best answer for another question', js: true do
    sign_in user2
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_selector('a', :class => 'best')
    end
  end

  scenario 'unauthenticated user choose the best answer for question' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_selector('a', :class => 'best')
    end
  end

end