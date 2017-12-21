# Attempting to override from Hyrax Gem 1.0.4:
#  app/indexers/hyrax/work_indexer.rb
# See config/application.rb for prepend statement

# TODO: Some of these shouldn't be in the generate solr document for 
#       a generic work.
#       Things like doi, extent and format should probably be part of an
#       indexer specific to a Vdc::Resource Indexer, since Vdc::Tools may
#       not have fields like those.
module Hyrax
  module Vdc
    module WorkIndexerOverride

      def generate_solr_document
        super.tap do |solr_doc|
          (solr_doc[Solrizer.solr_name('person_ids', :symbol)] ||= []) << object.vdc_creator
          solr_doc[Solrizer.solr_name('vdc_title', :stored_sortable)] = object.vdc_title.downcase if !object.vdc_title.nil?
          
          solr_doc[Solrizer.solr_name('extent')] = object.members.size
          solr_doc[Solrizer.solr_name('format')] = object.format          
          solr_doc[Solrizer.solr_name('identifier_doi')] = object.identifier_doi
        end
      end

    end
  end
end
