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
          uploaded_file_ids = filter_file_ids(env.attributes.delete(:uploaded_files))
          readme_file_id = filter_file_ids(env.attributes.delete(:readme_file))
          files = uploaded_files(uploaded_file_ids)
          rfile = readme_file(readme_file_id)
          validate_files(files, env) && validate_readme_file(rfile, env) && next_actor.create(env) && attach_files(files, env) && attach_readme_file(rfile, env)
        end

        # @param [Hyrax::Actors::Environment] env
        # @return [Boolean] true if update was successful
        def update(env)
          uploaded_file_ids = filter_file_ids(env.attributes.delete(:uploaded_files))
          readme_file_id = env.attributes.delete(:readme_file)
          files = uploaded_files(uploaded_file_ids)
          rfile = readme_file(readme_file_id)
          validate_files(files, env) && validate_readme_file(rfile, env) && next_actor.create(env) && attach_files(files, env) && attach_readme_file(rfile, env)
        end

        protected

          mattr_accessor :readme_file_id  
 
          # ensure that the readme files we are given are owned by the depositor of the work
          def validate_readme_file(readme_file, env)
            return true if readme_file.nil?
            expected_user_id = env.user.id
            if readme_file.user_id != expected_user_id
              Rails.logger.error "User #{env.user.user_key} attempted to ingest readme_file #{readme_file.id}, but it belongs to a different user"
              return false
            end
            true
          end

          # @return [TrueClass]
          def attach_readme_file(readme_file, env)
            return true unless readme_file
            AttachReadmeFilesToWorkJob.perform_later(env.curation_concern, readme_file, env.attributes.to_h.symbolize_keys)
            true
          end

          # Fetch readme_files from the database
          def readme_file(readme_file_id)
            return nil if readme_file_id.nil?
            UploadedFile.find(readme_file_id)
          end
      end
    end
  end
end
