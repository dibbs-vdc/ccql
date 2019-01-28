FactoryBot.define do
  factory :collection, aliases: [:small_collection] do
    sequence(:title)    { |n| ["Collection #{n}"] }
    collection_type_gid { FactoryBot.create(:collection_type).gid }
    collection_size { '1_gb' }

    factory :large_collection do
      collection_size { '1_tb' } # see config/authorities/collection_size.yml
    end

    trait :with_creation_date do
      after(:build) do |collection|
        collection.assign_creation_date
      end
    end
  end
end
