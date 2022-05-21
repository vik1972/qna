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
    user

    trait :invalid do
       title { nil }
    end

    trait :with_attachment do
      after :create do |question|
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                              filename: 'rails_helper.rb')

        def question.filename
          files[0].filename.to_s
        end
      end
    end

  end
end
