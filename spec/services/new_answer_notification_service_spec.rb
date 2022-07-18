require 'rails_helper'

RSpec.describe NewAnswerNotificationService do
  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question, user: users.first) }
  let(:answer) { create(:answer, question: question) }
  let(:subscr_first) { create(:subscription, question: question, user: users.first) }
  let(:subscr_last) { create(:subscription, question: question, user: users.last) }

  it "sends notification about new answer" do
    Subscription.find_each do |subscription|
      expect(NewAnswerMailer).to receive(:new_notification).with(subscription.user, answer).and_call_origin
    end
    subject.send_notification(answer)
  end

  context "unsubscribed user" do
    let(:user) { create(:user) }
    it "does not notification about new answer" do
      subject.send_notification(answer)
      expect(NewAnswerMailer).to_not receive(:new_notification).with(user, answer).and_call_original
    end
  end
end