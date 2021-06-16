# Generated via
#  `rails generate hyrax:work Vdc::Resource`

module Hyrax
  class Vdc::ResourcesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Vdc::Resource

    self.show_presenter = Hyrax::Vdc::ResourcePresenter

    def attributes_for_actor
      super.tap do |attributes|
        # TODO: Find out if there's a better way to get readme_file_ids_from_form,
        #       other than using a property from the resource model. Seems like there
        #       should be
        readme_file_ids_from_form = params.fetch(:readme_file_ids_from_form, nil)
        attributes[:funder] = [params["vdc_resource"]["funder"]]
        attributes[:readme_file_ids_from_form] = readme_file_ids_from_form
        attributes
      end
    end

    def new
      # Set the default vdc creator to be the current user when creating a new resource
      curation_concern.vdc_creator << current_user.identifier_system
      super
    end

    def create
      super
      perform_cu_post_processing
    end

    #def edit
    #  super
    #end

    def update
      super
      perform_cu_post_processing
    end

    # Post-processing for Create and Update
    # TODO: This is not going to work as expected most of the time. The files are attached
    # via background jobs, and chances are good that the background jobs will not have
    # finished running by the time this method is called.
    def perform_cu_post_processing
      # Reload to get all fields (including member extracted_text and mime_type)
      # loaded properly
      curation_concern.reload

      set_extent
      set_format

      curation_concern.save!

      # Reindex the members to get them into solr properly
      curation_concern.members.each{ |member| member.update_index }
    end

    def set_extent
      curation_concern.extent = curation_concern.members.size
    end

    # TODO: This is not going to work as expected most of the time. The files are attached
    # via background jobs, and chances are good that the background jobs will not have
    # finished running by the time this method is called.
    def set_format
      unique_formats = Set.new
      curation_concern.members.each do |member|
        unique_formats.add(member.mime_type) if member.respond_to?(:mime_type)
      end
      return if unique_formats.empty?
      curation_concern.format = unique_formats.to_a
    rescue ActiveTriples::Relation::ValueError => e
      Rails.logger.error("Unable to set format for work #{curation_concern.id}: #{e}")
      return nil
    end
  end
end
