# app/presenters/vdc/resource_presenter.rb
module Hyrax
  class Vdc::ResourcePresenter < Hyrax::WorkShowPresenter
    delegate :funder, :genre, to: :solr_document
  end
end

