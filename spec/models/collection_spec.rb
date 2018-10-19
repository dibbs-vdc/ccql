require 'rails_helper'

RSpec.describe Collection do
  subject(:collection) { described_class.new(title: ['Comet in Moominland']) }

  describe '#collection_size' do
    it 'handles expected values' do
      expect { collection.collection_size = '1_gb' }
        .not_to change { collection.valid? }
        .from true
    end
  end
end
