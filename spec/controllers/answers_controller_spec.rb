require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) {create(:question)}

  describe 'POST #create' do
    context 'with valid attributes' do

      let(:req) {post :create, params: {question_id: question, answer: attributes_for(:answer)}}

      it 'save new record' do
        expect{req}.to change(question.answers, :count).by(1)
      end
      it 'redirect to show view' do
        expect(req).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do

      let(:req) {post :create, params: {question_id: question, answer: attributes_for(:answer, :invalid)}}

      it 'does not save record' do
        expect {req}.to_not change(Answer, :count)
      end
      it 're-render new view' do
        expect(req).to render_template :new
      end
    end
  end

  describe 'GET #new' do
    before {get :new, params: {question_id: question}}

    it 'renders show new' do
      expect(response).to render_template(:new)
    end
  end
end
