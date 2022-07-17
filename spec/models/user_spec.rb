# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe "Check author" do
    let(:user) { create(:user) }
    let(:new_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it "current user is author" do
      expect(user).to be_author_of(question)
    end

    it "current user it's author" do
      expect(new_user).to_not be_author_of(question)
    end
  end

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: "github", uid: "123456") }
    let(:service) { double("FindForOauthService") }

    it "calls FindForOauthService" do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#subscribed_of?' do
    let(:user_not_sub) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:subscription) { create(:subscription, question: question, user: user) }

    it 'return true if user subscribed' do
      expect(user).to be_subscribed_of(question)
    end

    it 'return false if unsubscribed' do
      expect(user_not_sub).to_not be_subscribed_of(question)
    end
  end
end
