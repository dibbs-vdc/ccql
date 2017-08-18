# Generated via
#  `rails generate hyrax:work Vdc::Resource`

module Hyrax
  class Vdc::PeopleController < ApplicationController
    #include Hyrax::WorksControllerBehavior #TODO: Put back eventually?
    #include Hyrax::BreadcrumbsForWorks     #TODO: Put back eventually?
    #self.curation_concern_type = ::Vdc::Person #TODO: Put back eventually?

    #self.show_presenter = Hyrax::Vdc::ResourcePresenter #TODO: Put one eventually?

    def new
      self.vdc_type = "Person"
    end

    #def create
    #end

    def show
      id = params[:id]
      @person = ::Vdc::Person.find(id)
    rescue Ldp::Gone
      flash[:notice] = "This person (#{id}) no longer exists, and the linked data pointer is gone."
      redirect_to vdc_people_path
    end

    def index
      # TODO: Is there a better way to populate all of the
      @people = ::Vdc::Person.all
    end

    #def delete(user)
    #end

    #def edit
    #  super
    #end

    def destroy
      @person = ::Vdc::Person.find(params[:id])
      @person.destroy!
 
      redirect_to vdc_people_path
    end
  end
end
