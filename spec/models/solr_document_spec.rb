# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument do
  subject(:solr_document) { described_class.new(obj.to_solr) }
  let(:obj)              { FactoryBot.build(:dataset) }

  describe '#usage_count' do
    it 'is 0 by default' do
      expect(solr_document.usage_count).to eq 0
    end

    context 'when the resource exists' do
      let(:obj) { FactoryBot.create(:dataset) }

      it 'is 0 with no usages' do
        expect(solr_document.usage_count).to eq 0
      end
    end

    context 'with usage data' do
      let!(:usages) { FactoryBot.create_list(:vdc_usage, 2, work: obj) }
      let(:obj)    { FactoryBot.create(:dataset) }

      it 'accurately counts usages' do
        expect(solr_document.usage_count).to eq 2
      end

      it 'gives usage purposes' do
        expect(solr_document.usage_purposes).to contain_exactly('Fake Purpose String')
      end
    end
  end

  context 'with a collection' do
    let(:obj) { FactoryBot.build(:collection) }

    describe '#creation_date' do
      it 'is empty' do
        expect(solr_document.creation_date).to be_nil
      end

      context 'and a creation_date' do
        let(:obj) { FactoryBot.build(:collection, :with_creation_date) }

        it 'has a date' do
          expect(solr_document.creation_date)
            .to contain_exactly(match(/^[\d]{4}-[\d]{2}-[\d]{2}/))
        end
      end
    end
  end
end
