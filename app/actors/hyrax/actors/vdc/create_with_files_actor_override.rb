# Attempting to override from Hyrax Gem 2.0.0:
#   app/actors/hyrax/actors/create_with_files_actor.rb
# Modifications will allow for readme files to be ingested

module Hyrax
  module Actors
    module Vdc
      module CreateWithFilesActorOverride

        # @param [Hyrax::Actors::Environment] env
        # @return [Boolean] true if create was successful
        def create(env)
          super.tap do |success|
            if success
              readme_file_ids_from_form = filter_file_ids(env.attributes.delete(:readme_file_ids_from_form))
              rfile = readme_file(readme_file_ids_from_form)
              validate_readme_file(rfile, env) && attach_readme_file(rfile, env)
            end
          end
        end

        # @param [Hyrax::Actors::Environment] env
        # @return [Boolean] true if update was successful
        def update(env)
          super.tap do |success|
            if success
              readme_file_ids_from_form = filter_file_ids(env.attributes.delete(:readme_file_ids_from_form))
              rfile = readme_file(readme_file_ids_from_form)
              validate_readme_file(rfile, env) && attach_readme_file(rfile, env)
            end
          end
        end

        protected

          # ensure that the readme files we are given are owned by the depositor of the work
          # @return [TrueClass]
          def attach_readme_file(readme_file, env)
            return true unless readme_file
            AttachReadmeFilesToWorkJob.perform_later(env.curation_concern, [readme_file], env.attributes.to_h.symbolize_keys)
            true
          end

          # ensure that the files we are given are owned by the depositor of the work
          def validate_readme_file(readme_file, env)
            expected_user_id = env.user.id
            if (! readme_file.nil?) && (readme_file.user_id != expected_user_id)
              Rails.logger.error "User #{env.user.user_key} attempted to ingest readme_file #{readme_file.id}, but it belongs to a different user"
              return false
            end
            true
          end

          # Fetch readme_file from the database
          def readme_file(readme_file_id)
            return nil if readme_file_id.nil?
            readme_file = UploadedFile.find(readme_file_id)
            return nil if readme_file.empty?
            return readme_file.first # There should be at most one
          end
      end
    end
  end
end
