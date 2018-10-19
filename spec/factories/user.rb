FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }

    trait :approved do
      approved { true }
    end

    factory :approved_user, traits: [:approved]
  end
end
