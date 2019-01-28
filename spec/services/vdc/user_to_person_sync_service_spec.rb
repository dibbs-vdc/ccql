# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vdc::UserToPersonSyncService do
  subject(:service) { described_class.new(user: user) }
  let(:user)        { FactoryBot.create(:user) }

  describe '#create_person_from_user' do
    it 'creates a person' do
      expect { service.create_person_from_user }
        .to change { Vdc::Person.count }
        .by 1
    end
  end
end
