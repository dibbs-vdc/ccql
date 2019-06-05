FactoryBot.define do
  factory :person, class: 'Vdc::Person' do
    preferred_name { 'Papa, Moomin' }
  end
end
