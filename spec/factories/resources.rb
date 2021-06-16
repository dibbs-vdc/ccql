FactoryBot.define do
  factory :vdc_resource, class: 'Vdc::Resource' do
    title            { ['Titanic Passenger Survival Data Set'] }

    trait :ready_for_doi do
      vdc_title        { 'Titanic Passenger Survival Data Set' }
      creation_date    { [Hyrax::TimeService.time_in_utc.strftime('%Y-%m-%d')] }
      depositor        { (create :user, :full_name).email }
      vdc_creator      { [(create :person, email: depositor).id] }
      genre            { 'Data' }
      research_problem { 'test' }
      abstract         { 'lorem ipsum' }
    end

    trait :public do
      visibility { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
    end

    factory :dataset do
      vdc_title { 'Titanic Passenger Survival Data Set' }

      abstract do
        'This data set provides information on the fate of passengers on the ' \
        'fatal maiden voyage of the ocean liner "Titanic", summarized ' \
        'according to economic status (class), sex, age and survival.'
      end
    end

    factory :gis_dataset do
      title            { ['Puerto Rico Landslide Data'] }

      abstract do
        'One hundred twenty landslides were mapped and inferred to have occurred during the period of  ' \
        'strong ground shaking related to the January 7th, 2020 Puerto Rico Mw6.4 earthquake. Landslides are  ' \
        'widely dispersed with the highest concentration in the southwestern portion of the island, nearest the epicenter.'
      end

      factory :public_dataset_with_public_files, traits: [:public] do
        visibility { 'open' }
        after(:create) { |work, evaluator|
          2.times {
            work.ordered_members << FactoryBot.create(:public_file_set, depositor: evaluator.depositor)
          }
        }
      end
    end
  end
end
