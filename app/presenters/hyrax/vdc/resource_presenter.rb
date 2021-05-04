# app/presenters/vdc/resource_presenter.rb
module Hyrax
  class Vdc::ResourcePresenter < Hyrax::WorkShowPresenter
    delegate :vdc_type, :identifier_doi, :vdc_creator, :authoritative_name, :genre, :abstract, :funder, :research_problem, :note, :readme_file, :readme_abstract, :extent, :format, :discipline, :coverage_spatial, :coverage_temporal, :relation_uri, :relation_type, :creation_date, :vdc_license, :usage_count, :usage_purposes, to: :solr_document

    def globus_url
      Globus::Export.url_for(solr_document.id)
    end
  end
end
