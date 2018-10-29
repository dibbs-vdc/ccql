require 'rails_helper'

RSpec.describe Collection do
  subject(:collection) { FactoryBot.build(:collection) }

  describe '#collection_size' do
    it 'handles expected values' do
      expect { collection.collection_size = '1_gb' }
        .not_to change { collection.valid? }
        .from true
    end
  end

  describe '#apply_vdc_metadata' do
    it 'sets a creation_date' do
      expect { collection.apply_vdc_metadata }
        .to change { collection.creation_date.to_a }
        .to contain_exactly(an_instance_of(Date))
    end
  end

  describe '#assign_creation_date' do
    let(:datetime) { DateTime.now }
    let(:date)     { datetime.to_date }

    let(:fake_service) do
      class_double(Hyrax::TimeService, time_in_utc: datetime)
    end

    it 'assigns creation_date to now' do
      expect { collection.assign_creation_date(time_service: fake_service) }
        .to change { collection.creation_date.to_a }
        .to contain_exactly date
    end
  end
end
