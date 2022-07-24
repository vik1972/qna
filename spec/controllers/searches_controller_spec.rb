require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe "GET #index" do
    let!(:questions){ create_list(:question, 3) }
    subject { SearchService }

    context "with valid attributes" do
      SearchService::SCOPES.each do |scope|
        before do
          expect(subject).to receive(:call).and_return(questions)
          get :index, params: { query: questions.sample.title, scope: scope }
        end

        it "#{scope} return 2xx status" do
          expect(response).to be_successful
        end

        it "renders #{scope} index view" do
          expect(response).to render_template :index
        end

        it "#{scope} assign SearchService.call to @results" do
          expect(assigns(:results)).to eq questions
        end
      end
    end

    context 'with invalid attributes' do
      before do
        get :index, params: { query: questions.sample.title, scope: 'stub' }
      end

      it "renders index view" do
        expect(response).to render_template :index
      end
    end
  end
end
