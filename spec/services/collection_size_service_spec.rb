require 'rails_helper'

RSpec.describe CollectionSizeService do
  subject(:vocab)    { described_class.new }
  let(:active_id)    { '1_gb' }
  let(:active_label) { '<1 GB' }
  let(:active_term)  { [active_label, active_id] }


  describe '#active?' do
    it 'contains vocabulary terms' do
      expect(vocab.select_active_options).to include active_term
    end
  end

  describe '#select_active_options' do
    it 'contains vocabulary terms' do
      expect(vocab.active?(active_id)).to be_truthy
    end
  end
end
