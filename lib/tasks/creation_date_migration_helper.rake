# Run using: bundle exec rake vdc:creation_date_migration_helpers:convert

namespace :vdc do
  namespace :creation_date_migration_helpers do

    desc "Set creation_date from date_created for vdc resources and collections. Change date_created to be empty."

    def convert_collections
      collections = Collection.all
      convert_resources(collections)
    end

    def convert_vdc_resources
      vdc_resources = Vdc::Resource.all 
      convert_resources(vdc_resources)     
    end

    def convert_resources(resources)
      resources.each do |r| 
        if r.creation_date.empty?
          r.creation_date = r.date_created 
          puts "Setting #{r.class} (id #{r.id}) creation_date: #{r.creation_date.inspect}"
          r.save 
        end
        if ! r.date_created.empty?
          r.date_created = []
          puts "Setting #{r.class} (id #{r.id}) date_created: #{r.date_created.inspect}"
          r.save
        end
      end
    end

    task convert: :environment do
      convert_collections
      convert_vdc_resources
    end
  end
end
