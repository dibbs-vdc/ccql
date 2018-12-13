# frozen_string_literal: true

module Vdc
  class FileSetIndexer < Hyrax::FileSetIndexer
    self.thumbnail_path_service = Vdc::ResourceThumbnailPathService
  end
end
