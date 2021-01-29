FactoryBot.define do
  factory :globus_export, class: 'Globus::Export' do
    dataset_id { "MyString" }
    workflow_state { "MyString" }
  end
end
