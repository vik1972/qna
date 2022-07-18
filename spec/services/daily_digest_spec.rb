require 'rails_helper'

RSpec.describe DailyDigestService do
  let!(:users) { create_list(:user, 3) }
  let!(:yesterday_questions) { create_list(:question, 2, created_at: Date.yesterday, user: users.first) }

  it "sends daily digest to all users" do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, yesterday_questions).and_call_original }
    subject.send_digest
  end

end