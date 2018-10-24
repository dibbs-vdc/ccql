FactoryBot.define do
  factory :collection do
    sequence(:title)    { |n| ["Collection #{n}"] }
    collection_type_gid { FactoryBot.create(:collection_type).gid }
  end
end
