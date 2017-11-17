# TODO: Should extend from AttachFilesToWorkJob somehow... Not DRY
# TODO: Should be renamed to AttachReadmeFileToWorkJob (singular file)

# Converts UploadedFiles into FileSets and attaches them to works.
# Job specific for readme files
class AttachReadmeFilesToWorkJob < ActiveJob::Base
  queue_as Hyrax.config.ingest_queue_name

  # @param [ActiveFedora::Base] work - the work object
  # @param [UploadedFile] readme_file - a readme file to attach
  def perform(work, readme_file)
    file_set = FileSet.new
    user = User.find_by_user_key(work.depositor)
    actor = Hyrax::Actors::FileSetActor.new(file_set, user)
    actor.create_metadata(visibility: work.visibility)
    attach_content(actor, readme_file.file)
    actor.attach_file_to_work(work)
    actor.file_set.permissions_attributes = work.permissions.map(&:to_hash)
    delete_old_readme(work, user)
    readme_file.update(file_set_uri: file_set.uri)
    work.readme_file = file_set.uri
    work.save
  end

  private

    # TODO: Not sure if this is the best way to delete old work.
    #       Should I be trying to preserve versions instead? 
    #       If so, that will take a lot more work and undestanding.
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
