## Override file from Hyrax 2.5.1
# Modified #configure_facets method to set label directly rather than with I18n translations
# pending investigation into why this class is loaded before the I18n translations

module Hyrax
  class MyController < ApplicationController
    include Hydra::Catalog
    include Hyrax::Collections::AcceptsBatches

    # Define filter facets that apply to all repository objects.
    def self.configure_facets
      # clear facet's copied from the CatalogController
      blacklight_config.facet_fields = {}
      configure_blacklight do |config|
        # TODO: add a visibility facet (requires visibility to be indexed)
        # rutgers-vdc temporary fix for Visibility label pending fuller investigation (geekscruff)
        config.add_facet_field "visibility_ssi",
                               helper_method: :visibility_badge,
                               limit: 5, label: 'Visibility'
        config.add_facet_field IndexesWorkflow.suppressed_field, helper_method: :suppressed_to_status
        config.add_facet_field "resource_type_sim", limit: 5, label: 'Project Types'
      end
    end

    with_themed_layout 'dashboard'

    include Blacklight::Configurable

    copy_blacklight_config_from(CatalogController)
    configure_facets

    before_action :authenticate_user!
    load_and_authorize_resource only: :show, instance_name: :collection
    before_action :force_localizations
    # include the render_check_all view helper method
    helper Hyrax::BatchEditsHelper
    # include the display_trophy_link view helper method
    helper Hyrax::TrophyHelper

    def index
      @user = current_user
      (@response, @document_list) = query_solr
      prepare_instance_variables_for_batch_control_display

      respond_to do |format|
        format.html {}
        format.rss  { render layout: false }
        format.atom { render layout: false }
      end
    end

    private

      # TODO: Extract a presenter object that wrangles all of these instance variables.
      def prepare_instance_variables_for_batch_control_display
        # set up some parameters for allowing the batch controls to show appropriately
        max_batch_size = 80
        count_on_page = @document_list.count { |doc| batch.index(doc.id) }
        @disable_select_all = @document_list.count > max_batch_size
        @result_set_size = @response.response["numFound"]
        @empty_batch = batch.empty?
        @all_checked = (count_on_page == @document_list.count)
        @add_works_to_collection = params.fetch(:add_works_to_collection, '')
        @add_works_to_collection_label = params.fetch(:add_works_to_collection_label, '')
      end

      def query_solr
        search_results(params)
      end

      def force_localizations
        blacklight_config.facet_fields['collection_type_gid_ssim'].label = 'Project Types' if blacklight_config.facet_fields['collection_type_gid_ssim']
        blacklight_config.facet_fields['resource_type_sim'].label = 'Project Types' if blacklight_config.facet_fields['resource_type_sim']
        blacklight_config.facet_fields['visibility_ssi'].label = 'Visibility' if blacklight_config.facet_fields['visibility_ssi']
      end
  end
end
