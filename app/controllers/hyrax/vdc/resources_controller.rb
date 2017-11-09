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
      #TODO: consider using super.tap to avoid duplication

      attributes = super
      # If they selected a BrowseEverything file, but then clicked the                                                                                                
      # remove button, it will still show up in `selected_files`, but                                                                                                 
      # it will no longer be in uploaded_files. By checking the                                                                                                       
      # intersection, we get the files they added via BrowseEverything                                                                                                
      # that they have not removed from the upload widget.                                                                                                            
      uploaded_files = params.fetch(:uploaded_files, [])
      selected_files = params.fetch(:selected_files, {}).values
      browse_everything_urls = uploaded_files &
                               selected_files.map { |f| f[:url] }

      # we need the hash of files with url and file_name                                                                                                              
      browse_everything_files = selected_files
                                .select { |v| uploaded_files.include?(v[:url]) }

      readme_file = params.fetch(:readme_file, nil)

      attributes[:remote_files] = browse_everything_files
      # Strip out any BrowseEverthing files from the regular uploads.                                                                                                 
      attributes[:uploaded_files] = uploaded_files -
                                    browse_everything_urls

      # TODO: I don't understand this browse everything functionality. 
      # Do I need to subtract from the readme files before setting the readme_files attributes?
      attributes[:readme_file] = readme_file
  
      attributes
    end

    #def new
    #  super
    #end

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
      byebug

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
        unique_formats.add(member.mime_type)
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

