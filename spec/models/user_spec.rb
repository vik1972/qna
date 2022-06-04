# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  describe "Check author" do
    let(:user) { create(:user) }
    let(:new_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:reward) { create(:reward, question: question) }
    let(:answer) { create(:answer, question: question) }

    it 'current user is author' do
      expect(user).to be_author_of(question)
    end

    it "current user is't author" do
      expect(new_user).to_not be_author_of(question)
    end
  end
end
