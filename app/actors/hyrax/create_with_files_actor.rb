# Modified from Hyrax Gem 1.0.4

module Hyrax
  # Creates a work and attaches files to the work
  class CreateWithFilesActor < Hyrax::Actors::AbstractActor
    def create(attributes)
      self.uploaded_file_ids = attributes.delete(:uploaded_files)
      self.readme_file_id = attributes.delete(:readme_file)
      validate_files && validate_readme_file && next_actor.create(attributes) && attach_files && attach_readme_file
    end

    def update(attributes)
      self.uploaded_file_ids = attributes.delete(:uploaded_files)
      self.readme_file_id = attributes.delete(:readme_file)
      validate_files && validate_readme_file && next_actor.update(attributes) && attach_files && attach_readme_file
    end

    protected

      attr_reader :uploaded_file_ids
      def uploaded_file_ids=(input)
        @uploaded_file_ids = Array.wrap(input).select(&:present?)
      end

      attr_accessor :readme_file_id

      # ensure that the files we are given are owned by the depositor of the work
      def validate_files
        expected_user_id = user.id
        uploaded_files.each do |file|
          if file.user_id != expected_user_id
            Rails.logger.error "User #{user.user_key} attempted to ingest uploaded_file #{file.id}, but it belongs to a different user"
            return false
          end
        end
        true
      end

      # ensure that the readme files we are given are owned by the depositor of the work
      def validate_readme_file
        return true if readme_file.nil?
        expected_user_id = user.id
        if readme_file.user_id != expected_user_id
          Rails.logger.error "User #{user.user_key} attempted to ingest readme_file #{readme_file.id}, but it belongs to a different user"
          return false
        end
        true
      end

      # @return [TrueClass]
      def attach_files
        return true unless uploaded_files
        AttachFilesToWorkJob.perform_later(curation_concern, uploaded_files)
        true
      end

      # @return [TrueClass]
      def attach_readme_file
        return true unless readme_file
        AttachReadmeFilesToWorkJob.perform_later(curation_concern, readme_file)
        true
      end

      # Fetch uploaded_files from the database
      def uploaded_files
        return [] if uploaded_file_ids.empty?
        @uploaded_files ||= UploadedFile.find(uploaded_file_ids)
      end

      # Fetch readme_files from the database
      def readme_file
        return nil if readme_file_id.nil?
        @readme_file ||= UploadedFile.find(readme_file_id)
      end
  end
end
