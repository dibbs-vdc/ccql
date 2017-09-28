# Generated via
#  `rails generate hyrax:work Vdc::Resource`

module Hyrax
  class Vdc::ResourcesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Vdc::Resource

    self.show_presenter = Hyrax::Vdc::ResourcePresenter

    def new
      super
      # TODO: find a way to replace this lookup via solr instead... fedora lookups are supposedly expensive
      person = ::Vdc::Person.find(current_user.identifier_system)
      if person == nil
        # TODO: Eventually throw some error here. A person shouldn't be able to create a new resource if
        #       They don't have an entry in Fedora
        # TODO: Am I using a presenter correctly here...?
        user_profile_presenter = Hyrax::UserProfilePresenter.new(current_user, current_ability)
        @default_creator = user_profile_presenter.full_name+" (missing fedora entry)"
      else
        @default_creator = person.preferred_name
      end      
    end

    #def create
    #  byebug
    #  super
    #end

    def edit
      super
      # TODO: find a way to replace this lookup via solr instead... fedora lookups are supposedly expensive
      person = ::Vdc::Person.find(@form.vdc_creator)

      # TODO: error handling if person is not found.
      @default_creator = person.preferred_name
    end
  end
end

