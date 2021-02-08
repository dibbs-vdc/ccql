# frozen_string_literal: true
# Exports file attachments to a directory for download by Globus
module Globus
  class ExportJob < Hyrax::ApplicationJob
    queue_as Hyrax.config.ingest_queue_name

    # @param [String] an identifier for an ActiveFedora::Base object
    def perform(work_id)
      Globus::Export.call(work_id)
    end
  end
end
