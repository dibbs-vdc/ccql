# Generated via
#  `rails generate hyrax:work Vdc::Resource`

module Hyrax
  class Vdc::ResourcesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Vdc::Resource

    self.show_presenter = Hyrax::Vdc::ResourcePresenter
  end
end
