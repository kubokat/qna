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

    context 'author' do
      before { login(user) }

      it 'delete the answer' do
        expect { req }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question' do
        req
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not author' do
      before { login(user2) }

      it 'deletes the answer' do
        expect { req }.to_not change(Answer, :count)
      end

      it 'redirect to question' do
        req
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
