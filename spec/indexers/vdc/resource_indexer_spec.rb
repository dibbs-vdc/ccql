# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vdc::ResourceIndexer do
  subject(:indexer) { described_class.new(resource) }
  let(:resource)    { FactoryBot.build(:dataset) }

  describe '#generate_solr_document' do
    it 'downcases sortable :vdc_title' do
      expect(indexer.generate_solr_document)
        .to include('vdc_title_ssi' => 'titanic passenger survival data set')
    end

    context 'with usage data' do
      let(:resource) { FactoryBot.create(:vdc_resource) }
      let(:usages)   { FactoryBot.create_list(:vdc_usage, 2, work: resource) }

      before { usages }

      it 'indexes usage count' do
        expect(indexer.generate_solr_document)
          .to include('usage_count_ssm' => 2)
      end

      it 'indexes usage purposes'
    end
  end
end
