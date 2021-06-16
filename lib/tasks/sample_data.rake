# Run using: bundle exec rake vdc:generate_sample_data
require 'ffaker'

namespace :vdc do

  desc "Generate sample data"
  task generate_sample_data: :environment do
    user = FactoryBot.create(:admin_user, email: FFaker::Internet.email, display_name: FFaker::Name.name , password: 'testing123')
    Vdc::UserToPersonSyncService.new({user: user}).create_person_from_user(user)
    # collection = FactoryBot.create(:large_public_collection,
    #   title: ["Fake Sample Data: #{FFaker::Music.song}"],
    #   depositor: user.user_key,
    #   collection_type_gid: 'gid://ccql/hyrax-collectiontype/1'
    # )
    dataset = FactoryBot.create(:vdc_resource, depositor: user.user_key, title: [ "Sample Data: #{FFaker::Book.title}"], visibility: 'open' )
    2.times {
      dataset.ordered_members << FactoryBot.create(:public_file_set, user: user, depositor: user.user_key)
    }
    dataset.save
    # collection.members << dataset
    gis_data_files = ['Puerto_Rico_Landslides-shp.zip', 'Puerto_Rico_Landslides.kml']

    # Attach known files to a work so we can tell whether the export happened as expected
    fs1 = dataset.file_sets.first
    fs2 = dataset.file_sets.last
    file1 = Rails.root.join('spec', 'fixtures', gis_data_files.first)
    file2 = Rails.root.join('spec', 'fixtures', gis_data_files.last)
    File.open(file1) do |f|
      Hydra::Works::UploadFileToFileSet.call(fs1, f)
      fs1.title = [file1.basename.to_s]
      fs1.label = file1.basename.to_s
      fs1.save
    end
    File.open(file2) do |f|
      Hydra::Works::UploadFileToFileSet.call(fs2, f)
      fs2.title = [file2.basename.to_s]
      fs2.label = gis_data_files.last
      fs2.save
    end
    puts "Generated dataset: #{dataset.title.first}"
  end
end
