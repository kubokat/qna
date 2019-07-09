# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:req) { post :create, params: { answer: attributes_for(:answer), question_id: question } }

      it 'save new record' do
        expect { req }.to change(question.answers, :count).by(1)
      end

      it 'check answer user relation' do
        req
        expect(assigns(:answer).user_id).to eq subject.current_user.id
      end

      it 'redirect to show view' do
        expect(req).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      let(:req) { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

      it 'does not save record' do
        expect { req }.to_not change(Answer, :count)
      end
      it 're-render new view' do
        expect(req).to render_template 'questions/show'
      end
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'renders show new' do
      expect(response).to render_template(:new)
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user: user, question: question) }
    let(:req) { delete :destroy, params: { id: answer } }
    let(:user2) { create(:user) }

    it 'delete the answer with author' do
      expect { req }.to change(Answer, :count).by(-1)
    end

    it 'deletes the question without author' do
      login(user2)
      expect { req }.to_not change(Answer, :count)
    end
  end
end
