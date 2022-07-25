FactoryBot.define do
  factory :comment do
    sequence :body do |n|
      "Comment body #{n}"
    end

    trait :invalid do
      body { nil }
    end
  end
end
