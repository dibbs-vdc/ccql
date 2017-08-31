# app/presenters/vdc/resource_presenter.rb
module Hyrax
  class Vdc::ResourcePresenter < Hyrax::WorkShowPresenter
    delegate :vdc_type, :identifier_doi, :vdc_creator, :authoritative_name, :genre, :abstract, :funder, :research_problem, :note, :readme, :extent, :format, :coverage_spatial, :coverage_temporal, to: :solr_document
  end
end
