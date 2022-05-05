require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      let(:new_answer) { post :create, params: { answer: attributes_for(:answer), question_id: question } }
      it 'saves a new answer in the database' do
        expect{ new_answer }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        new_answer
        expect(response).to redirect_to assigns(:question)
      end

      context 'with invalid attributes' do
        let!(:new_answer) { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }
        it 'does not save the answer' do
          expect{ new_answer }.to_not change(question.answers, :count)
        end
      end
    end
  end

  describe 'DELETE #destroy' do

      let!(:answer) { create(:answer, question: question, user: user )}

      context 'The author can delete his question or answer' do
        before { login(user) }
        it 'check that answer was deleted' do
          delete :destroy, params: {id: answer}
          expect(assigns(:answer)).to be_destroyed
        end

        it 'redirects to questions list' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'User is not author' do
        let(:not_author) { create(:user) }
        before { login(not_author) }

        it 'tries to delete answer' do
          expect { delete :destroy, params: { id: answer} }.to_not change(Answer, :count)
        end

        it 'redirects to questions list' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'Unauthorised user' do
        it 'tries to delete answer' do
          expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
        end

        it 'redirects to login page' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to new_user_session_path
        end
      end

  end
end
