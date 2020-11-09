require 'rails_helper'

RSpec.describe Hyrax::Vdc::ResourceForm do
  subject       { form }
  let(:work)    { Vdc::Resource.new }
  let(:ability) { Ability.new(nil) }
  let(:request) { nil }
  let(:form)    { described_class.new(work, ability, request) }
  let(:all_terms) do
    [
    :title,
    :representative_id,
    :thumbnail_id,
    :rendering_ids,
    :files,
    :visibility_during_embargo,
    :embargo_release_date,
    :visibility_after_embargo,
    :visibility_during_lease,
    :lease_expiration_date,
    :visibility_after_lease,
    :visibility,
    :ordered_member_ids,
    :in_works_ids,
    :member_of_collection_ids,
    :admin_set_id,
    :vdc_creator,
    :genre,
    :research_problem,
    :abstract,
    :vdc_license,
    :funder,
    :note,
    :discipline,
    :coverage_spatial,
    :coverage_temporal,
    :relation_type,
    :relation_uri,
    :readme_abstract
  ]
end
  let(:required_fields) { [:title, :vdc_creator, :genre] }

  it 'has the expected terms' do
    expect(Set.new(form.terms)).to eq(Set.new(all_terms))
  end

  it "has the expected required terms" do
    expect(Set.new(form.required_fields)).to eq(Set.new(required_fields))
  end
end
