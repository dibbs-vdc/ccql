# frozen_string_literal: true
require 'rails_helper'

module Globus
  RSpec.describe ExportJob, globus: true  do
    let(:user) { FactoryBot.create(:user) }
    let(:dataset) { FactoryBot.create(:public_dataset_with_public_files, depositor: user.user_key) }

    it "calls Globus::Export for a specific id" do
      expect(Globus::Export).to receive(:call)
      described_class.perform_now(dataset.id)
    end
  end
end
