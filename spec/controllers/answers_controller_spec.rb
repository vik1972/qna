require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  describe 'POST #create' do
    context 'with valid attributes' do
      let(:new_answer) { post :create, params: { answer: attributes_for(:answer), question_id: question } }
      it 'saves a new answer in the database' do
        expect{ new_answer }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        new_answer
        expect(response).to redirect_to assigns(:answer)
      end

      context 'with invalid attributes' do
        let!(:new_answer) { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }
        it 'does not save the answer' do
          expect{ new_answer }.to_not change(question.answers, :count)
        end

        it 're-renders new view' do
          expect(response).to render_template :new
        end
      end
    end
  end
end
