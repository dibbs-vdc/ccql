# TODO: Should be renamed to AttachReadmeFileToWorkJob (singular file)

# Converts UploadedFiles into FileSets and attaches them to works.
# Job specific for readme files and deletes old one.
class AttachReadmeFilesToWorkJob < AttachFilesToWorkJob

  # @param [ActiveFedora::Base] work - the work object
  # @param [Array<Hyrax::UploadedFile>] uploaded_files - files to attach - for readme files, there should only be 1
  def perform(work, uploaded_files, **work_attributes)
    validate_files!(uploaded_files)
    user = User.find_by_user_key(work.depositor) # BUG? file depositor ignored                                                                                                 
    work_permissions = work.permissions.map(&:to_hash)
    metadata = visibility_attributes(work_attributes)
    uploaded_files.each do |uploaded_file|
      actor = Hyrax::Actors::FileSetActor.new(FileSet.create, user)
      actor.create_metadata(metadata)
      actor.create_content(uploaded_file)
      actor.attach_to_work(work)
      actor.file_set.permissions_attributes = work_permissions
      uploaded_file.update(file_set_uri: actor.file_set.uri)
      delete_old_readme(work, user)
      work.readme_file = actor.file_set.uri
      work.save
    end
  end

  private

    # TODO: This is not the best way to delete an old work.
    #       I should be trying to preserve versions,
    #       which will take a lot more work and undestanding.
    def delete_old_readme(work, user)
       rfat = work.readme_file
       if rfat.is_a? ActiveTriples::Resource
         rf_url = rfat.rdf_subject.to_s # example: "http://127.0.0.1:8984/rest/dev/1f/13/0a/00/1f130a00-32c3-4452-b601-b5b520d699fa"
         rf_fedora_id = ActiveFedora::Base.uri_to_id(rf_url)
         rf_file_set = FileSet.find(rf_fedora_id)
         rf_actor = Hyrax::Actors::FileSetActor.new(rf_file_set, user)
         rf_actor.destroy
       end
    end

    # @param [Hyrax::Actors::FileSetActor] actor
    # @param [Hyrax::UploadedFileUploader] file file.file must be a CarrierWave::SanitizedFile or file.url must be present
    def attach_content(actor, file)
      if file.file.is_a? CarrierWave::SanitizedFile
        actor.create_content(file.file.to_file)
      elsif file.url.present?
        actor.import_url(file.url)
      else
        raise ArgumentError, "#{file.class} received with #{file.file.class} object and no URL"
      end
    end
end
