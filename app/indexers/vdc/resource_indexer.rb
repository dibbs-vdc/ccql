# frozen_string_literal: true

module Vdc
  ##
  # A specialized `Hyrax::WorkIndexer` handling `Vdc::Resource` metadata.
  class ResourceIndexer < Hyrax::WorkIndexer
    ##
    # Custom indexing behavior for Resources
    def generate_solr_document
      super.tap do |solr_doc|
        if object.vdc_title
          solr_doc[Solrizer.solr_name('vdc_title', :stored_sortable)] =
            object.vdc_title.downcase
        end

        (solr_doc[Solrizer.solr_name('person_ids', :symbol)] ||= []) <<
          object.vdc_creator

        solr_doc[Solrizer.solr_name('extent')] = object.members.size
        solr_doc[Solrizer.solr_name('format')] = object.format
        solr_doc[Solrizer.solr_name('identifier_doi')] = object.identifier_doi
      end
    end
  end
end
