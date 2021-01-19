FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    display_name { "Jane Doe" }

    trait :approved do
      approved { true }
    end

    trait :full_name do
      first_name { 'John' }
      last_name  { 'Doe' }
    end

    factory :admin_user, traits: [:approved] do
      email { 'admin@example.com' }
    end

    factory :approved_user, traits: [:approved]
  end
end
