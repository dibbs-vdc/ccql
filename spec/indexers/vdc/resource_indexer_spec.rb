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
  end
end
