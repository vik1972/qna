# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'MyString' }
    url { 'https://mysite.post' }
  end

  trait :invalid do
    name { 'Bad_Url' }
    url { 'bad://mysite_post' }
  end
end
