# Attempting to override from Hyrax Gem 2.0.0:
#   app/controllers/hyrax/collections_controller.rb

module Hyrax
  module Vdc
    module CollectionsControllerOverride

      def self.prepended(base)
        base.form_class = Hyrax::Vdc::CollectionForm
        base.presenter_class = Hyrax::Vdc::CollectionPresenter
      end

      def new
        super.tap do |form|
          form.vdc_creator << current_user.identifier_system
        end
      end

      def after_create
        @collection.apply_vdc_metadata
        if @collection.save
          super
        else
          after_create_error
        end

        CollectionSizeNotification
          .new(collection: @collection)
          .notify
      end

      def after_update
        @collection.apply_vdc_metadata
        if @collection.update(collection_params.except(:members))
          super
        else
          after_update_error
        end

        CollectionSizeNotification
          .new(collection: @collection)
          .notify
      end
    end
  end
end
