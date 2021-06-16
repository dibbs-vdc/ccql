# Run using: bundle exec rake vdc:vdc_license_migration_helper:convert

namespace :vdc do
  namespace :globus do

    desc "Export all public works for download with Globus"
    task export_all: :environment do
      Globus::Export.export_all
    end
  end
end
