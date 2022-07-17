# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe "for guest" do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe "for admin" do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe "for user" do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create :question, user: user }
    let(:other_question) { create :question, user: other }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    context "Question" do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, create(:question, user: user) }
      it { should_not be_able_to :update, create(:question, user: other) }

      it { should be_able_to :destroy, create(:question, user: user) }
      it { should_not be_able_to :destroy, create(:question, user: other) }

      it { should be_able_to [:vote_up, :cancel_vote, :vote_down], create(:question, user: other) }
      it { should_not be_able_to [:vote_up, :cancel_vote, :vote_down], create(:question, user: user) }
    end

    context "Answer" do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, create(:answer, user: user) }
      it { should_not be_able_to :update, create(:answer, user: other) }

      it { should be_able_to :destroy, create(:answer, user: user) }
      it { should_not be_able_to :destroy, create(:answer, user: other) }

      it { should be_able_to [:vote_up, :cancel_vote, :vote_down], create(:answer, question: question, user: other) }
      it { should_not be_able_to [:vote_up, :cancel_vote, :vote_down], create(:answer, question: question, user: user) }
    end

    context "Comment" do
      it { should be_able_to :create, Comment }
    end

    context "Link" do
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }
    end

    context "Attachment" do
      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end

    context "Subscription" do
      it { should be_able_to :create, Subscription}

      it { should be_able_to :destroy, create(:subscription, question: other_question, user: user) }
      it { should_not be_able_to :destroy, create(:subscription, question: question, user: other) }
    end
  end
end