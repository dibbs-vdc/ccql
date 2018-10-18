require 'rails_helper'

RSpec.describe User do
  subject(:user) { FactoryBot.build(:user) }

  describe '#approved?' do
    it 'sets to true when approving' do
      expect { user.approved = true }
        .to change { user.approved? }.to true
    end

    context 'with already approved user' do
      subject(:user) { FactoryBot.build(:approved_user) }

      it { is_expected.to be_approved }
    end
  end
end
