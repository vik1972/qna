require "rails_helper"

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: author) }
  let!(:link1) { create(:link, linkable: question) }
  let!(:link2) { create(:link, linkable: answer) }

  describe "DELETE #destroy" do
    context "Answer's author can delete link from his answer " do
      before { login(author) }

      it "check that link was deleted" do
        expect { delete :destroy, params: {id: link2}, format: :js }.to change(answer.links, :count).by(-1)
      end

      it "renders destroy view" do
        delete :destroy, params: {id: link1}, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "Answer's author can delete link from his question " do
      before { login(user) }

      it "check that link was deleted" do
        expect { delete :destroy, params: {id: link1}, format: :js }.to change(question.links, :count).by(-1)
      end

      it "renders destroy view" do
        delete :destroy, params: {id: link1}, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "Unauthenticated user" do
      it "trys to delete link from answer" do
        expect { delete :destroy, params: {id: link2}, format: :js }.to_not change(answer.links, :count)
      end

      it "redirects to new session view" do
        delete :destroy, params: {id: link2}
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "Unauthenticated user" do
      it "trys to delete link from question" do
        expect { delete :destroy, params: {id: link1}, format: :js }.to_not change(question.links, :count)
      end

      it "redirects to new session view" do
        delete :destroy, params: {id: link1}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
