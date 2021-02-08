# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Hyrax::Actors::CreateWithRemoteFilesAndGlobusDownloadActor, globus: true do
  let(:actor) { described_class.new(next_actor) }
  let(:next_actor) { instance_double('Hyrax::Actors::BaseActor', create: true, update: true, destroy: true) }
  let(:user) { FactoryBot.create(:user) }
  let(:dataset) { FactoryBot.build(:public_dataset_with_public_files, depositor: user.user_key) }
  let(:attrs) { { } }
  let(:env) { instance_double('Hyrax::Actors::Environment', curation_concern: dataset, attributes: attrs) }

  before do
    Redis.current.flushall
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#create' do
    before { actor.create(env) }

    it 'enqueues a job to export files' do
      expect(::Globus::ExportJob).to have_been_enqueued
    end
  end

  describe '#update' do
    before { actor.update(env) }

    it 'enqueues a job to export files' do
      expect(::Globus::ExportJob).to have_been_enqueued
    end
  end
end
