require 'rails_helper'

RSpec.describe Vdc::Usage, type: :model do
  subject(:usage)    { FactoryBot.build(:vdc_usage) }
  let(:bad_work_gid) { 'fake work gid' }

  it 'is invalid with a non gid:// #work_gid' do
    expect { usage.work_gid = bad_work_gid }
      .to change { usage.valid? }
      .to false
  end

  describe '#work' do
    context 'with no #work_gid' do
      subject(:usage) { FactoryBot.build(:vdc_usage, work_gid: nil) }

      it 'returns nil' do
        expect(usage.work).to be_nil
      end
    end

    context 'with a missing #work_gid' do
      it 'raises ActiveFedora::ObjectNotFoundError' do
        expect { usage.work }
          .to raise_error ActiveFedora::ObjectNotFoundError
      end
    end
  end

  describe '#work=' do
    subject(:usage) { FactoryBot.build(:vdc_usage, work: old_work) }
    let(:new_work)  { FactoryBot.create(:vdc_resource) }
    let(:old_work)  { FactoryBot.create(:vdc_resource) }

    it 'sets the work' do
      expect { usage.work = new_work }
        .to change { usage.work }
        .to new_work
    end

    context 'with an unsaved work' do
      let(:new_work) { FactoryBot.build(:vdc_resource) }

      it 'sets the work' do
        expect { usage.work = new_work }
          .to raise_error URI::GID::MissingModelIdError
      end
    end
  end
end
