FactoryBot.define do
  factory :vdc_resource, class: 'Vdc::Resource' do
    title { ['Titanic Passenger Survival Data Set'] }

    factory :dataset do
      vdc_title { 'Titanic Passenger Survival Data Set' }

      abstract do
        'This data set provides information on the fate of passengers on the ' \
        'fatal maiden voyage of the ocean liner "Titanic", summarized ' \
        'according to economic status (class), sex, age and survival.'
      end
    end
  end
end
