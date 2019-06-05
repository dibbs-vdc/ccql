# app/presenters/vdc/resource_presenter.rb
module Hyrax
  class Vdc::CollectionPresenter < Hyrax::CollectionPresenter
    delegate :vdc_type, :vdc_creator, :abstract, :funder, :collection_size, :note, to: :solr_document

    def self.terms
      [:total_items, :size, :creation_date,
       :vdc_type, :vdc_creator, :abstract, :funder, :collection_size, :note]
    end

    ##
    # Display only date, not time
    def creation_date
      if solr_document && solr_document.creation_date
        solr_document.creation_date.map do |datetime_str|
          datetime_str.split('T').first
        end
      else
        []
      end
    end

    ##
    # Override CollectionPresenter#[], which behaves erratically: instead of
    # giving the Presenter's version of the field, it delegates simply to
    # `solr_document`. This is unfortunate, since Hyrax uses this method as the
    # default field display.
    #
    # The most reliable fix is to override this method, pending its deprecation
    # and removal from Hyrax.
    def [](key)
      return creation_date if key.to_sym == :creation_date
      super
    end
  end
end
