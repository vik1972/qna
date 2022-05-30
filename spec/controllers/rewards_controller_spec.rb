require "rails_helper"

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:reward) { create(:reward, question: question, user: user) }

  describe "GET #index" do
    let(:questions) { create_list(:question, 4, user: user) }
    context "Rewarded user" do
      before { login(user) }
      before { get :index }

      it "render index view" do
        expect(response).to render_template :index
      end
    end
  end
end
