require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      let(:new_answer) { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js}
      it 'saves a new answer in the database' do
        expect{ new_answer }.to change(question.answers, :count).by(1)
      end

      it 'redirects to create template' do
        new_answer
        expect(response).to render_template :create
      end

      context 'with invalid attributes' do
        let!(:new_answer) { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }
        it 'does not save the answer' do
          expect{ new_answer }.to_not change(question.answers, :count)
        end

        it 'render question create template' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question) }

    context 'Authorized user edits his answer' do
      before { login(user) }

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
        it 'does not save the answer' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
        end

        it 'renders create template' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end
    end
  end

    describe 'DELETE #destroy' do

      let!(:answer) { create(:answer, question: question, user: user )}

      context 'The author can delete his question or answer' do
        before { login(user) }
        it 'check that answer was deleted' do
          delete :destroy, params: {id: answer}, format: :js
          expect(assigns(:answer)).to be_destroyed
        end

        it 'render destroy template' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'User is not author' do
        let(:not_author) { create(:user) }
        before { login(not_author) }

        it 'tries to delete answer' do
          expect { delete :destroy, params: { id: answer}, format: :js }.to_not change(Answer, :count)
        end

        it 'render destroy template' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'Unauthorised user' do
        it 'tries to delete answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
        end
      end

  end
end
