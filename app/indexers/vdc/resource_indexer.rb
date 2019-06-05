# frozen_string_literal: true

module Vdc
  ##
  # A specialized `Hyrax::WorkIndexer` handling `Vdc::Resource` metadata.
  class ResourceIndexer < Hyrax::WorkIndexer
    USAGE_QUERY_CLASS = Vdc::ResourceUsage

    self.thumbnail_path_service = Vdc::ResourceThumbnailPathService

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

        add_usage_data(solr_doc)
      end
    end

    private

      def add_usage_data(solr_doc)
        return :no_op if object.new_record?

        usage = USAGE_QUERY_CLASS.new(resource: object)
        count = Solrizer.solr_name('usage_count', :displayable, type: :integer)
        purposes = Solrizer.solr_name('usage_purposes', :facetable)

        solr_doc[count]    = usage.count
        solr_doc[purposes] = usage.purposes
      end
  end
end
