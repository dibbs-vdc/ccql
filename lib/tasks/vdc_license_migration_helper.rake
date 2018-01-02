# Run using: bundle exec rake vdc:vdc_license_migration_helper:convert

namespace :vdc do
  namespace :vdc_license_migration_helper do

    desc "Set vdc_license to 'https://opendatacommons.org/licenses/by/1-0/' for vdc resources. Change license to be empty."

    task convert: :environment do
      vdc_resources = Vdc::Resource.all
      vdc_resources.each do |r| 
        r.vdc_license = "https://opendatacommons.org/licenses/by/1-0/"
        r.license = []
        r.save
      end
    end
  end
end
