# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    title { 'MyReward' }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/app/assets/images/reward.png") }
    association :question, factory: :question
  end
end
