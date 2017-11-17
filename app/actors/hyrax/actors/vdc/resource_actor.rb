# Generated via
#  `rails generate hyrax:work Vdc::Resource`
module Hyrax
  module Actors
    class Vdc::ResourceActor < Hyrax::Actors::BaseActor
      def create(attributes)
        super
        post_processing(attributes)
      end

      def update(attributes)
        super
        post_processing(attributes)
      end

      private
   
        def post_processing(attributes)
          # NOTE: This actor seems to do post-processing BEFORE the uploaded files have
          #       been processed. So, I'm adding processing that doesn't depend on
          #       information on its members (like, getting the number of files and mime 
          #       infomration.
          # TODO: Consider putting this in the controller post-processing?
          curation_concern.vdc_type = curation_concern.human_readable_type
          curation_concern.vdc_title = curation_concern.title[0]
          curation_concern.identifier_system = curation_concern.id # TODO: Redundant?
          curation_concern.save!

          # TODO: Assign these eventually --
          # curation_concern.identifier_doi = ?
          # curation_concern.authoritative_name = ?
          # curation_concern.authoritative_name_uri = ?

          true
        end
    end
  end
end
