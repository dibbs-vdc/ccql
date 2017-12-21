# Modified from Hyrax Gem 1.0.4

# frozen_string_literal: true
module Hyrax
  class CollectionThumbnailPathService < Hyrax::ThumbnailPathService
    class << self
      def default_image
        ActionController::Base.helpers.image_path 'project_logo.jpg'
      end
    end
  end
end
