require 'rails_helper'

RSpec.describe User, type: :model do
  it {should have_many(:questions).dependent(:destroy) }
  it {should have_many(:answers).dependent(:destroy) }

  describe 'Check author' do
    let(:user) { create(:user) }
    let(:new_user) { create(:user) }
    let(:question)  { create(:question, user: user) }
    it 'current user is author' do
      expect(user).to be_author_of(question)
    end

    it "current user is't author" do
      expect(new_user).to_not be_author_of(question)
    end
  end
end
