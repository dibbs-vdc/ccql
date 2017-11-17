# Attempting to override from Hyrax Gem 1.0.4:
#  app/indexers/hyrax/work_indexer.rb
# See config/application.rb for prepend statement

module Hyrax
  module Vdc
    module CollectionIndexerOverride

      def generate_solr_document
        super.tap do |solr_doc|
          (solr_doc[Solrizer.solr_name('person_ids', :symbol)] ||= []) << object.vdc_creator
          solr_doc[Solrizer.solr_name('vdc_title', :stored_sortable)] = object.vdc_title.downcase if !object.vdc_title.nil?
        end
      end

    end
  end
end
