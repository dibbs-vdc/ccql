require 'rails_helper'

RSpec.describe Globus::Export, globus: true do

  after { described_class.destroy_all }

  describe ".call" do
    let(:user) { FactoryBot.create(:user) }
    let(:dataset) { FactoryBot.create(:public_dataset_with_public_files, depositor: user.user_key) }
    let(:export) { described_class.call(dataset) }
    let(:gis_data_files) { ['Puerto_Rico_Landslides-shp.zip', 'Puerto_Rico_Landslides.kml'] }
    let(:files) { [] }

    # Attach known files to a work so we can tell whether the export happened as expected
    before do
      fs1 = dataset.file_sets.first
      fs2 = dataset.file_sets.last
      file1 = File.join(fixture_path, gis_data_files.first)
      file2 = File.join(fixture_path, gis_data_files.last)
      File.open(file1) do |f|
        Hydra::Works::UploadFileToFileSet.call(fs1, f)
      end
      File.open(file2) do |f|
        Hydra::Works::UploadFileToFileSet.call(fs2, f)
      end
    end

    it "exports the dataset (once)" do
      expect(dataset.visibility).to eq "open"
      expect(dataset.members.first.visibility).to eq "open"
      # expect(export).to be_exported
      # expect(File.exist?(export.export_path)).to be true
      # expect(File.exist?(File.join(export.export_path, Rdr.globus_export_readme_filename))).to be true
      # expect(File.exist?(File.join(export.export_path, Rdr.globus_export_manifest_filename))).to be true
      # files.each do |file|
      #   expect(File.exist?(File.join(export.export_path, file))).to be true
      # end
      # expect_any_instance_of(described_class).not_to receive(:build)
      # expect_any_instance_of(described_class).not_to receive(:export)
      # described_class.call(dataset)
    end

    # it "makes files read-only, not executable" do
    #   files.each do |path|
    #     file = File.join(export.export_path, path)
    #     expect(File.readable?(file)).to be true
    #     expect(File.writable?(file)).to be false
    #     expect(File.executable?(file)).to be false
    #   end
    # end
  end

end
