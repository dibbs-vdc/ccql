# Attempting to override from Hyrax Gem 1.0.4:
#  app/indexers/hyrax/work_indexer.rb
# See config/application.rb for prepend statement

module Hyrax
  module Vdc
    module WorkIndexerOverride

      def generate_solr_document
        super.tap do |solr_doc|
          (solr_doc[Solrizer.solr_name('person_ids', :symbol)] ||= []) << object.vdc_creator
          # TODO: Find out why I need to explicitly add this here? Is it because
          #       extent and format aren't part of the form?
          solr_doc[Solrizer.solr_name('extent')] = object.members.size
          object.members.each do |member|
            (solr_doc[Solrizer.solr_name('format')] ||= []) << member.to_solr["mime_type_ssi"]
          end
        end
      end

    end
  end
end
