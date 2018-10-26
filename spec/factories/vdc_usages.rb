FactoryBot.define do
  factory :vdc_usage, class: 'Vdc::Usage' do
    work_gid { 'gid://fake/Vdc::Resource/gid' }
    user
    purpose { 'Fake Purpose String' }
  end
end
