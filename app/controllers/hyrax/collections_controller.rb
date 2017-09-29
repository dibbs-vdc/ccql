# Modified from Hyrax Gem 1.0.4

module Hyrax
  class CollectionsController < ApplicationController
    include CollectionsControllerBehavior
    include BreadcrumbsForCollections
    
    self.form_class = Hyrax::Vdc::CollectionForm
    self.presenter_class = Hyrax::Vdc::CollectionPresenter

    def after_create
      @collection.apply_vdc_metadata
      if @collection.save
        super
      else
        after_create_error
      end
    end

    def after_update
      @collection.apply_vdc_metadata
      if @collection.update(collection_params.except(:members))
        super
      else
        after_update_error
      end
    end
  end
end
