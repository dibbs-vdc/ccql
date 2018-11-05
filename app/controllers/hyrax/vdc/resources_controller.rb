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
    def perform_cu_post_processing
      # Reload to get all fields (including member extracted_text and mime_type) 
      # loaded properly
      curation_concern.reload 

      set_extent
      set_format
      set_doi

      curation_concern.save!
      
      # Reindex the members to get them into solr properly
      curation_concern.members.each{ |member| member.update_index } 
    end

    def set_extent
      curation_concern.extent = curation_concern.members.size
    end

    def set_format
      unique_formats = Set.new
      curation_concern.members.each do |member|
        if member.respond_to? (:mime_type)
          unique_formats.add(member.mime_type) unless member.mime_type == nil
        end
      end
      curation_concern.format = unique_formats.to_a
    end

    def set_doi
      # Generate DOI if the work is public  
      if curation_concern.visibility == Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
        curation_concern.identifier_doi = ::Vdc::DoiGenerationService.new({work: curation_concern}).generate_doi
      end
    end
  end
end

