# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::Vdc::CollectionForm do
  subject(:form)   { described_class.new(collection, ability, solr_doc) }
  let(:collection) { FactoryBot.build(:collection) }
  let(:ability)    { :fake_ability }
  let(:solr_doc)   { :fake_solr_document }

  describe '#primary_terms' do
    it 'all primary terms are also terms' do
      expect(form.primary_terms - form.terms).to be_empty
    end
  end

  describe '#required_fields' do
    it 'all required fields are also terms' do
      expect(form.required_fields - form.terms).to be_empty
    end
  end

  describe '#terms' do
    it 'excludes :creation_date' do
      expect(form.terms).not_to include :creation_date
    end
  end
end
