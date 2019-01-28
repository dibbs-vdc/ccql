module Vdc
  class ResourceThumbnailPathService < Hyrax::ThumbnailPathService

    class ThumbnailImageResolver
      ##
      # @param [#mime_type] object
      # @return [String, nil] a string representing the path for a thumbnail image; nil when no match
      def image_path_for(object)
        case object.mime_type
        when 'text/csv'
          ActionController::Base.helpers.image_path 'file-csv.svg'
        when 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
          ActionController::Base.helpers.image_path 'file-excel.svg'
        when 'image/png', 'image/jpeg'
          ActionController::Base.helpers.image_path 'file-image.svg'
        when 'application/json'
          ActionController::Base.helpers.image_path 'file-json.svg'
        when 'application/pdf'
          ActionController::Base.helpers.image_path 'file-pdf.svg'
        when 'application/octet-stream'
          ActionController::Base.helpers.image_path 'file-sav.svg'
        when 'text/plain'
          ActionController::Base.helpers.image_path 'file-text.svg'
        when 'video/quicktime', 'video/mp4'
          ActionController::Base.helpers.image_path 'file-video.svg'
        when 'application/zip'
          ActionController::Base.helpers.image_path 'file-zip.svg'
        end
      end
    end

    def self.call(object, image_resolver: ThumbnailImageResolver.new)
      result = super(object)
      return result unless result == default_image
      return default_image unless object.thumbnail_id
      thumb = fetch_thumbnail(object)
      return default_image unless thumb
      return call(thumb) unless thumb.is_a?(::FileSet)
      image_resolver.image_path_for(thumb) || default_image
    end
  end
end
