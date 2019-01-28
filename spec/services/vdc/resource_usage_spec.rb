require 'rails_helper'

RSpec.describe Vdc::ResourceUsage do
  subject(:service) { described_class.new(resource: resource) }
  let(:resource)    { FactoryBot.create(:vdc_resource) }

  shared_context 'with usages' do
    let(:usages) { FactoryBot.create_list(:vdc_usage, 2, work: resource) }

    before { usages }
  end

  context 'with an unsaved resource' do
    let(:resource) { FactoryBot.build(:vdc_resource) }

    it 'raises MissingModelIdError on initialize' do
      expect { subject }.to raise_error URI::GID::MissingModelIdError
    end
  end

  describe '.usages_for' do
    it 'is empty' do
      expect(described_class.usages_for(resource: resource)).to be_empty
    end

    context 'with usages' do
      include_context 'with usages'

      it 'returns the usages' do
        expect(described_class.usages_for(resource: resource))
          .to contain_exactly(*usages)
      end
    end
  end

  describe '#usages' do
    it 'is empty' do
      expect(service.usages).to be_empty
    end

    context 'with usages' do
      include_context 'with usages'

      it 'returns the usages' do
        expect(service.usages).to contain_exactly(*usages)
      end
    end
  end

  describe '#count' do
    it 'is 0' do
      expect(service.count).to eq 0
    end

    context 'with usages' do
      include_context 'with usages'

      it 'gives an accurate count' do
        expect(service.count).to eq 2
      end
    end
  end

  describe '#purposes' do
    it 'is empty' do
      expect(service.purposes).to be_empty
    end

    context 'with usages' do
      let(:purpose_1) { 'purpose #1' }
      let(:purpose_2) { 'purpose #2' }

      before do
        FactoryBot.create(:vdc_usage, work: resource, purpose: purpose_1)
        FactoryBot.create(:vdc_usage, work: resource, purpose: purpose_1)
        FactoryBot.create(:vdc_usage, work: resource, purpose: purpose_2)
      end

      it 'returns the usages' do
        expect(service.purposes).to contain_exactly(purpose_1, purpose_2)
      end
    end
  end
end
