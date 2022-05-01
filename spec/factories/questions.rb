FactoryBot.define do
  sequence :title do |n|
    "TitleQuestion#{n}"
  end
  sequence :body do |n|
    "BodyQuestion#{n}"
  end

  factory :question do
    title
    body

    trait :invalid do
       title { nil }
    end
  end
end
