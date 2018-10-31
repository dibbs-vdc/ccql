# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument do
  subject(:solr_document) { described_class.new(work.to_solr) }
  let(:work)              { FactoryBot.build(:dataset) }

  describe '#usage_count' do
    it 'is 0 by default' do
      expect(solr_document.usage_count).to eq 0
    end

    context 'when the resource exists' do
      let(:work) { FactoryBot.create(:dataset) }

      it 'is 0 with no usages' do
        expect(solr_document.usage_count).to eq 0
      end
    end

    context 'with usage data' do
      let!(:usages) { FactoryBot.create_list(:vdc_usage, 2, work: work) }
      let(:work)    { FactoryBot.create(:dataset) }

      it 'accurately counts usages' do
        expect(solr_document.usage_count).to eq 2
      end

      it 'gives usage purposes' do
        expect(solr_document.usage_purposes).to contain_exactly('Fake Purpose String')
      end
    end
  end
end
