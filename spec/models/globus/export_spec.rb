require 'rails_helper'
require 'fileutils'

RSpec.describe Globus::Export, globus: true do

  after { described_class.destroy_all }

  describe ".call" do
    let(:user) { FactoryBot.create(:user) }
    let(:dataset) { FactoryBot.create(:public_dataset_with_public_files, depositor: user.user_key) }
    let(:export) { described_class.call(dataset) }
    let(:gis_data_files) { ['Puerto_Rico_Landslides-shp.zip', 'Puerto_Rico_Landslides.kml'] }
    let(:globus_export_path) { Rails.root.join('tmp', 'globus_export_path').to_s }
    let(:fake_origin_id) { 'FAKE_ORIGIN_ID' }
    let(:files) { [] }

    # Attach known files to a work so we can tell whether the export happened as expected
    before do
      fs1 = dataset.file_sets.first
      fs2 = dataset.file_sets.last
      file1 = File.join(fixture_path, gis_data_files.first)
      file2 = File.join(fixture_path, gis_data_files.last)
      File.open(file1) do |f|
        Hydra::Works::UploadFileToFileSet.call(fs1, f)
        fs1.label = gis_data_files.first
        fs1.save
      end
      File.open(file2) do |f|
        Hydra::Works::UploadFileToFileSet.call(fs2, f)
        fs2.label = gis_data_files.last
        fs2.save
      end
    end

    ##
    # Set ENV['GLOBUS_EXPORT_PATH'] to a tmp directory for the purposes of this test,
    # but ensure it gets set back to whatever it was before once the test has finished.
    around(:each) do |example|
      FileUtils.rm_rf globus_export_path
      Dir.mkdir globus_export_path
      globus_export_path_orig = ENV['GLOBUS_EXPORT_PATH']
      globus_export_origin_id_orig = ENV['GLOBUS_EXPORT_ORIGIN_ID']
      ENV['GLOBUS_EXPORT_PATH'] = globus_export_path
      ENV['GLOBUS_EXPORT_ORIGIN_ID'] = fake_origin_id
      example.run
      FileUtils.rm_rf globus_export_path
      ENV['GLOBUS_EXPORT_PATH'] = globus_export_path_orig
      ENV['GLOBUS_EXPORT_ORIGIN_ID'] = globus_export_origin_id_orig
    end

    context "setting the export location" do
      it "has an export_path" do
        ge = described_class.new
        expect(ge.export_path).to eq globus_export_path
      end
    end

    context "workflow state" do
      it "is new if it hasn't been exported yet" do
        ge = described_class.new
        expect(ge.workflow_state).to eq 'new'
        expect(ge.new?).to eq true
        expect(ge.exported?).to eq false
        expect(ge.error?).to eq false
      end

      it "is exported if the export is complete" do
        ge = export
        expect(ge.workflow_state).to eq 'exported'
        expect(ge.new?).to eq false
        expect(ge.exported?).to eq true
        expect(ge.error?).to eq false
      end

      # TODO: Better checking for error state.
      xit "is error if it encounters an error" do
        lambda do
          allow(FileUtils).to receive(:mkdir_p).and_raise(Exception)
          ge = export
          expect(ge.workflow_state).to eq 'error'
        end
      end
    end

    context "export" do
      it "exports the dataset (once)" do
        expect(File.exist?(export.export_path)).to be true
        expect(File.exist?(File.join(export.export_path, dataset.id, gis_data_files.first))).to be true
        expect(File.exist?(File.join(export.export_path, dataset.id, gis_data_files.last))).to be true
        expect(export).to be_exported
      end
    end

    context "#url_for" do
      it "gets the Globus url for a given dataset" do
        url = "https://app.globus.org/file-manager?origin_id=FAKE_ORIGIN_ID&origin_path=%2F#{dataset.id}%2F"
        expect(described_class.url_for(dataset.id)).to eq url
      end
    end
  end

end