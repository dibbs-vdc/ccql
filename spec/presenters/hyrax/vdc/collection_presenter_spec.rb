# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::Vdc::CollectionPresenter do
  subject(:presenter) { described_class.new(solr_doc, ability) }
  let(:ability)       { :not_an_ability }
  let(:collection)    { build(:collection) }
  let(:solr_doc)      { SolrDocument.new(collection.to_solr) }

  describe '.terms' do
    it 'has a creation_date term' do
      expect(described_class.terms).to include :creation_date
    end
  end

  describe '#[]' do
    let(:collection) { build(:collection, :with_creation_date) }

    it 'gives the presenter creation date' do
      expect(presenter[:creation_date])
        .to contain_exactly(match(/^[\d]{4}-[\d]{2}-[\d]{2}$/))
    end
  end

  describe '#creation_date' do
    it 'is empty' do
      expect(presenter.creation_date).to be_empty
    end

    context 'with a creation_date' do
      let(:collection) { build(:collection, :with_creation_date) }

      it 'formats the date' do
        expect(presenter.creation_date)
          .to contain_exactly(match(/^[\d]{4}-[\d]{2}-[\d]{2}$/))
      end
    end
  end
end
