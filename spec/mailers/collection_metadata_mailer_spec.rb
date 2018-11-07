# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionMetadataMailer do
  subject(:mailer) { described_class.with(collection: collection) }
  let(:collection) { FactoryBot.build(:large_collection) }
  let(:user)       { FactoryBot.build(:admin_user) }

  describe '#size_message' do
    it do
      message = mailer.size_message.deliver_now

      expect(message.to_s).to include "#{collection.title.first} was created"
    end
  end
end
