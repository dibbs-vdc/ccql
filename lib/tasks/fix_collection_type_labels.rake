namespace :hyrax do
  desc "Fix missing collection type labels"
  task :fix_collection_type_labels => :environment do
    collection_types = Hyrax::CollectionType.all
    collection_types.each do |c|
      next unless c.title =~ /^translation missing/
      oldtitle = c.title
      c.title = I18n.t(c.title.gsub("translation missing: en.", ''))
      c.save
      puts "#{oldtitle} changed to #{c.title}"
    end
  end
end
