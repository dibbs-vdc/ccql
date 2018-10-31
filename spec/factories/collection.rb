FactoryBot.define do
  factory :collection do
    sequence(:title)    { |n| ["Collection #{n}"] }
    collection_type_gid { FactoryBot.create(:collection_type).gid }
    collection_size '1_gb'

    factory :large_collection do
      collection_size '1_tb' # see config/authorities/collection_size.ymlo
    end
  end
end
