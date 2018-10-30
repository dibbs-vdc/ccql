FactoryBot.define do
  factory :vdc_usage, class: 'Vdc::Usage' do
    work_gid { 'gid://fake/Vdc::Resource/gid' }
    user
    purpose { 'Fake Purpose String' }
  end

  trait :with_resource do
    work_gid { create(:vdc_resource).to_global_id }
  end
end
