Hyrax.config.callback.set(:after_create_fileset) do |file_set, user|
  FileSetAttachedEventJob.perform_later(file_set, user)
  Globus::Export.file_set_added(file_set)
end
