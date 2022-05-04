require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

    describe 'GET #show' do
      let(:question) { create(:question) }
      before { get :show, params: { id: question } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end

    describe "GET #new" do

      before { login(user) }

      before { get :new }
      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect{ post :create, params:{ question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params:{ question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end
      context 'with invalid attributes' do
        it 'does not save the question' do
          expect{ post :create, params:{ question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params:{ question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:question) { create(:question, user: user) }

      context 'User is author' do
        before { login(user) }

        it 'checks that question was deleted' do
          delete :destroy, params: { id: question }
          expect(assigns(:question)).to be_destroyed
        end

        it 'redirects to questions list' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'User is not an author' do
        let(:not_author) { create(:user) }
        before { login(not_author) }

        it 'tries to delete question' do
          delete :destroy, params: { id: question }
          expect{delete :destroy, params: {id: question}}.to_not change(Question, :count)
        end

        it 'redirects to questions list' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'Unauthorised user' do
        it 'tries to delete question' do
          delete :destroy, params: { id: question }
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end

        it 'redirects to login page' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

  end
end
