require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe "POST #create" do
    context "Authenticated user creates comment with valid attributes" do
      before { login(user) }

      it "save a new comment to database" do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(question.comments, :count).by(1)
      end

      it "render create" do
        post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context "Authenticated user creates comment with invalid attributes" do
      it "don't save a new comment to database" do
        expect do
          post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js
        end .to change(question.comments, :count).by(0)
      end
    end

  end
end
