# Generated via
#  `rails generate hyrax:work Vdc::Resource`

module Hyrax
  module Actors
    class Vdc::ResourceActor < Hyrax::Actors::BaseActor
      PRIVATE = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
      PUBLIC = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
      VDC = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED

      def create(env)
        set_creation_date(env)
        super
        post_processing(env)
      end

      def update(env)
        update_creation_date(env)
        super
        post_processing(env)
      end

      private

        def set_creation_date(env)
          env.curation_concern.creation_date = [Hyrax::TimeService.time_in_utc.strftime('%Y-%m-%d')]
        end

        def update_creation_date(env)
          visibility = env.attributes[:visibility] 
          original_visibility = ::Vdc::Resource.find(env.curation_concern.id).visibility
          if (visibility == PUBLIC || visibility == VDC) && original_visibility == PRIVATE
            env.curation_concern.creation_date = [Hyrax::TimeService.time_in_utc.strftime('%Y-%m-%d')]
          end
        end
   
        def post_processing(env)
          # NOTE: This actor seems to do post-processing BEFORE the uploaded files have
          #       been processed. So, I'm adding processing that doesn't depend on
          #       information on its members (like, getting the number of files and mime 
          #       infomration.
          # TODO: Consider putting this in the controller post-processing?
          env.curation_concern.vdc_type = env.curation_concern.human_readable_type
          env.curation_concern.vdc_title = env.curation_concern.title[0]
          env.curation_concern.identifier_system = env.curation_concern.id # TODO: Redundant?
          env.curation_concern.save!
        end
    end
  end
end
