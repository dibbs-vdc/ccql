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

  describe '#display_name' do
    it 'defaults to #to_s' do
      expect(user.display_name).to eq user.to_s
    end

    context 'with a missing name' do
      subject(:user)   { FactoryBot.build(:user, first_name: first_name) }
      let(:first_name) { 'Moomin' }

      it 'falls back on #to_s' do
        expect(user.display_name).to eq user.to_s
      end
    end

    context 'with first and last name' do
      subject(:user)   { FactoryBot.build(:user, first_name: first_name, last_name: last_name) }
      let(:first_name) { 'Moomin' }
      let(:last_name)  { 'Papa' }

      it 'gives "last, first"' do
        expect(user.display_name).to eq 'Papa, Moomin'
      end
    end
  end
end
