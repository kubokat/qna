# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'author_of?' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }
    let!(:answer) { create(:answer, user: author, question: question) }

    it 'question belongs to user' do
      expect(author).to be_author_of(question)
    end

    it 'question does not belongs to user' do
      expect(user).to_not be_author_of(question)
    end
  end
end
