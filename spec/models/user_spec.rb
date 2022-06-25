# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  describe "Check author" do
    let(:user) { create(:user) }
    let(:new_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:reward) { create(:reward, question: question) }
    let(:answer) { create(:answer, question: question) }

    it "current user is author" do
      expect(user).to be_author_of(question)
    end

    it "current user is't author" do
      expect(new_user).to_not be_author_of(question)
    end
  end

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: "github", uid: "123456") }

    context "user already has authorization" do
      it "rerturns the user" do
        user.authorizations.create(provider: "github", uid: "123456")
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context "user has not authorization" do
      context "user already exists" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "github", uid: "123456", info: { email: user.email }) }
        it "does not creat new user" do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it "creates authorization for user" do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it "creates authorization with provider and uid" do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it "returns the user" do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context "user does not exist" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "github", uid: "123456", info: { email: "new@user.com"}) }

        it "create new user" do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it "returns new user" do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it "fills user email" do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it "creates authorization for user" do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it "creates authorization with provider and uid" do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
