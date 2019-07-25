# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe 'set_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer1) { create(:answer, question: question, user: user) }
    let(:answer2) { create(:answer, question: question, user: user) }

    before { answer1.set_best }

    it 'choose answer as the best' do
      expect(answer1).to be_best
    end

    it 'change best answer' do
      answer2.set_best
      answer1.reload
      expect(answer1).not_to be_best
      expect(answer2).to be_best
    end
  end
end
