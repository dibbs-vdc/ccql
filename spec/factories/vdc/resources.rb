FactoryBot.define do
  factory :vdc_resource, class: Vdc::Resource do
    title ["Test Vdc Resource Title"]
    vdc_type "Resource"
    identifier_system "123"
    identifier_doi "Test DOI"
    vdc_creator ["test_creator_id"]
    authoritative_name "Placeholder"
    authoritative_name_uri "PlaceholderURI"
    vdc_title "Test Title"
    genre "Data"
    abstract "Test Abstract"
    funder ["Test Funder 1", "Test Funder 2"]
    research_problem "Test Research Problem"
    note ["Test Note"]
    creation_date ["2017-12-05"]
    readme_file "Test README File"
    readme_abstract "Test Readme abstract"
    extent "0"
    format []
    discipline ["Test Discipline"]
    coverage_spatial ["Test Spatial"]
    coverage_temporal ["Test Temporal"]
    relation_uri ["http://www.google.com"]
    relation_type ["isReferrencedBy"]
    vdc_license "https://opendatacommons.org/licenses/by/1-0/"
  end
end
