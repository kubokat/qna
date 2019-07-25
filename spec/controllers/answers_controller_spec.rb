# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:req) { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }

      it 'save new record' do
        expect { req }.to change(question.answers, :count).by(1)
      end

      it 'check answer user relation' do
        req
        expect(assigns(:answer).user_id).to eq subject.current_user.id
      end

      it 'redirect to show view' do
        expect(req).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:req) { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }

      it 'does not save record' do
        expect { req }.to_not change(Answer, :count)
      end
      it 're-render new view' do
        expect(req).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:req) { delete :destroy, params: { id: answer }, format: :js }
    let(:user2) { create(:user) }

    context 'author' do
      before { login(user) }

      it 'delete the answer' do
        expect { req }.to change(Answer, :count).by(-1)
      end

      it 'render template destroy' do
        req
        expect(response).to render_template :destroy
      end
    end

    context 'not author' do
      before { login(user2) }

      it 'deletes the answer' do
        expect { req }.to_not change(Answer, :count)
      end

      it 'render template destroy' do
        req
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, user: user, question: question) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #best' do
    context 'author' do

      it 'choose the answer as the best' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to be_best
      end
    end

    context 'not author' do
      let(:user2) { create(:user) }
      before { login(user2) }

      it 'not choose the answer as the best' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).not_to be_best
      end
    end
  end
end
