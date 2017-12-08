# Generated via
#  `rails generate hyrax:work Vdc::Resource`
module Hyrax
  module Actors
    class Vdc::ResourceActor < Hyrax::Actors::BaseActor
      def create(env)
        byebug
        apply_update_data_to_curation_concern(env)
        apply_save_data_to_curation_concern(env)
        post_processing(env)
        #save(env) && next_actor.create(env) && run_callbacks(:after_create_concern, env) # TODO: Why doesn't this work?
        save(env) && next_actor.create(env) && run_callbacks(:after_update_metadata, env)
      end

      def update(env)
        apply_update_data_to_curation_concern(env)
        apply_save_data_to_curation_concern(env)
        post_processing(env)
        next_actor.update(env) && save(env) && run_callbacks(:after_update_metadata, env)
      end

      private
   
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
          true
        end
    end
  end
end
