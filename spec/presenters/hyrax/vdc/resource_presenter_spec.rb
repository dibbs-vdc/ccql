# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hyrax::Vdc::ResourcePresenter do
  subject(:presenter) { described_class.new(document, ability, request) }
  let(:ability)       { :fake_ability }
  let(:document)      { SolrDocument.new(work.to_solr) }
  let(:request)       { :fake_request }
  let(:work)          { FactoryBot.build(:dataset) }

  describe '#usage_count' do
    it { expect(presenter.usage_count).to eq 0 }
  end

  describe '#usage_purposes' do
    it { expect(presenter.usage_purposes).to be_empty }
  end
end
