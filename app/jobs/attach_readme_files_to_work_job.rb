# TODO: Should be renamed to AttachReadmeFileToWorkJob (singular file)

# Converts UploadedFiles into FileSets and attaches them to works.
# Job specific for readme files and deletes old one.
class AttachReadmeFilesToWorkJob < AttachFilesToWorkJob

  # @param [ActiveFedora::Base] work - the work object
  # @param [Array<Hyrax::UploadedFile>] readme_file - file to attach
  def perform(work, readme_file, **work_attributes)
    validate_files!([readme_file])
    user = User.find_by_user_key(work.depositor) # BUG? file depositor ignored                                                                                                 
    work_permissions = work.permissions.map(&:to_hash)
    metadata = visibility_attributes(work_attributes)
    actor = Hyrax::Actors::FileSetActor.new(FileSet.create, user)
    actor.create_metadata(metadata)
    actor.create_content(readme_file)
    actor.attach_to_work(work)
    actor.file_set.permissions_attributes = work_permissions
    delete_old_readme(work, user)
    readme_file.update(file_set_uri: actor.file_set.uri)
    work.readme_file = actor.file_set.uri
    work.save
  end

  private

    # TODO: This is not the best way to delete an old work.
    #       I should be trying to preserve versions,
    #       which will take a lot more work and undestanding.
    def delete_old_readme(work, user)
       rfat = work.readme_file
       if rfat
         rf_url = rfat.rdf_subject.to_s # example: "http://127.0.0.1:8984/rest/dev/1f/13/0a/00/1f130a00-32c3-4452-b601-b5b520d699fa"
         rf_fedora_id = URI(rf_url).path.split('/').last # get id at the end of url
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
