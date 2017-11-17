# app/presenters/vdc/resource_presenter.rb
module Hyrax
  class Vdc::CollectionPresenter < Hyrax::CollectionPresenter
    delegate :vdc_type, :vdc_creator, :abstract, :funder, :collection_size, :note, to: :solr_document

    def self.terms
      [:total_items, :size, :date_created, 
       :vdc_type, :vdc_creator, :abstract, :funder, :collection_size, :note]
    end

  end
end

