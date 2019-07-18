# frozen_string_literal: true

require 'rails_helper'

feature 'Users show question' do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'All users can show questions' do
    visit root_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
