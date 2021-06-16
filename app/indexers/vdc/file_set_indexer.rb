# frozen_string_literal: true

module Vdc
  class FileSetIndexer < Hyrax::FileSetIndexer
    self.thumbnail_path_service = Vdc::ResourceThumbnailPathService
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc['parent_ssi'] = object.parent&.id
      end
    end
  end
end
