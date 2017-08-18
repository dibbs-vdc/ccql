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
          curation_concern.vdc_type = curation_concern.human_readable_type
          curation_concern.vdc_title = curation_concern.title[0]
          curation_concern.identifier_system = curation_concern.id # TODO: Redundant?

          # It looks like curation_concern.members 
          # is a FileSet of uploaded files attached to the work.          
          curation_concern.extent = curation_concern.members.size
          # curation_concern.members[0].mime_type # TODO: what to do with mimetype? set format?

          # TODO: default creator is last_name, first_name for now. take this out
          #       once the Person object stabilizes
          curation_concern.vdc_creator = "#{user.last_name}, #{user.first_name}"

          if user.identifier_system != nil         
            person = ::Vdc::Person.find(user.identifier_system) 
            # TODO: Decide what to do when we eventually allow more than one creator
            curation_concern.vdc_creator = RDF::URI(person.uri) if person != nil
          end
          #byebug
          
          curation_concern.save!

          # TODO: Assign these eventually --
          # curation_concern.identifier_doi = ?
          # curation_concern.authoritative_name = ?
          # curation_concern.authoritative_name_uri = ?
          # curation_concern.format = ?

          # TODO: REMOVE DEBUGGING          
          #puts "attributes.inspect -- " + attributes.inspect
          #puts "user.inspect -- " + user.inspect
          #puts "curation_concern.inspect -- " + curation_concern.inspect
          #puts "resource dump -- " + curation_concern.resource.dump(:ttl)          
          #byebug

          true
        end
    end
  end
end
