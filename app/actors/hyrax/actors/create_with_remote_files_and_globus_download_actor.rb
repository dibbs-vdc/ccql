module Hyrax
  module Actors
    ##
    # Extend CreateWithRemoteFilesActor so that after the files are attached a
    # job is enqueued to export the attached files for Globus download.
    class CreateWithRemoteFilesAndGlobusDownloadActor < CreateWithRemoteFilesActor
      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if create was successful
      def create(env)
        remote_files = env.attributes.delete(:remote_files)
        next_actor.create(env) && attach_files(env, remote_files) && queue_for_globus(env)
      end

      # @param [Hyrax::Actors::Environment] env
      # @return [Boolean] true if update was successful
      def update(env)
        remote_files = env.attributes.delete(:remote_files)
        next_actor.update(env) && attach_files(env, remote_files) && queue_for_globus(env)
      end

      private

      def queue_for_globus(env)
        ::Globus::ExportJob.perform_later(env.curation_concern.id)
      end
    end
  end
end
