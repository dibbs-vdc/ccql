FactoryBot.define do
  factory :person, class: 'Vdc::Person' do
    preferred_name { 'Papa, Moomin' }
    email { 'papa@moomin.org' }
  end
end
