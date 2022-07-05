# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      let(:new_answer) { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }
      it 'saves a new answer in the database' do
        expect { new_answer }.to change(question.answers, :count).by(1)
      end

      it 'redirects to create template' do
        new_answer
        expect(response).to render_template :create
      end

      context 'with invalid attributes' do
        let!(:new_answer) do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        end
        it 'does not save the answer' do
          expect { new_answer }.to_not change(question.answers, :count)
        end

        it 'render answer create template' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
          expect(response).to render_template :create
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'Authorized user edits his answer' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body'} }, format: :js
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
          expect do
            post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question },
                          format: :js
          end.to_not change(Answer, :count)
        end

        it 'renders create template' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'The author can delete his question or answer' do
      before { login(user) }
      it 'check that answer was deleted' do
        delete :destroy, params: { id: answer }, format: :js
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to redirect_to root_path
      end
    end

    context 'Unauthorised user' do
      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end
  end
  describe 'PATCH #mark_best' do
    let(:author) { create(:user) }
    let(:new_question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: new_question, user: user) }

    context 'Unauthenticated user' do
      it 'tries do mark as best answer' do
        answer.best = false
        patch :mark_as_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload
        expect(answer.best).to eq false
      end
    end

    context 'User is author of question' do
      before { login(author) }

      it 'mark best answer' do
        patch :mark_as_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload
        expect(answer.best).to be
      end

      it 'renders mark_as_best view' do
        patch :mark_as_best, params: { id: answer, answer: { body: 'new body' }, format: :js }
        expect(response).to render_template :mark_as_best
      end
    end
  end

  it_behaves_like "voted"

end
