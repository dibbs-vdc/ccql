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

    #def create
    #  byebug
    #  super
    #end

    #def edit
    #  super
    #end
  end
end

