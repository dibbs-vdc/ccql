# Override from Hyrax to add file set to export
class CharacterizeJob < Hyrax::ApplicationJob
  queue_as Hyrax.config.ingest_queue_name
  include Hyrax::Lockable
  # Characterizes the file at 'filepath' if available, otherwise, pulls a copy from the repository
  # and runs characterization on that file.
  # @param [FileSet] file_set
  # @param [String] file_id identifier for a Hydra::PCDM::File
  # @param [String, NilClass] filepath the cached file within the Hyrax.config.working_path
  def perform(file_set, file_id, filepath = nil)
    raise "#{file_set.class.characterization_proxy} was not found for FileSet #{file_set.id}" unless file_set.characterization_proxy?
    filepath = Hyrax::WorkingDirectory.find_or_retrieve(file_id, file_set.id) unless filepath && File.exist?(filepath)
    Hydra::Works::CharacterizationService.run(file_set.characterization_proxy, filepath)
    Rails.logger.debug "Ran characterization on #{file_set.characterization_proxy.id} (#{file_set.characterization_proxy.mime_type})"
    file_set.characterization_proxy.save!
    file_set.update_index
    file_set.parent&.in_collections&.each(&:update_index)
    add_to_export(file_set)
    CreateDerivativesJob.perform_later(file_set, file_id, filepath)
  end

  def add_to_export(file_set)
    if file_set.parent
      acquire_lock_for(file_set.parent.id) do
        export = Globus::Export.find_by(dataset_id: file_set.parent.id)
        if export && !export.completed_file_sets.include?(file_set.id)
          export.completed_file_sets << file_set.id
          export.save!
          if export.ready_for_globus?
            Globus::ExportJob.perform_later(export.dataset_id)
          end
        end
      end
    end
  end
end
