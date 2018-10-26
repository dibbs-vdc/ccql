FactoryBot.define do
  factory :vdc_usage, class: 'Vdc::Usage' do
    work_gid { "MyString" }
    user { nil }
    purpose { "MyString" }
  end
end
