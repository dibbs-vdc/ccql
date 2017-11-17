module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

    def link_to_person_profile(args)
      key = args[:document][args[:field]]
      # TODO: error handling if person can't be found or there's more than 1 key
      person_id = key.first
      link_to_person_profile_with_id(person_id)
    end

    def link_to_person_profile_with_id(person_id)
      person_doc = person_doc(person_id)
      text = preferred_name(person_doc)
      user = User.find_by(identifier_system: person_doc['id'])
      link_to text, Hyrax::Engine.routes.url_helpers.profile_path(user)
    rescue URI::InvalidURIError
      # TODO: Should I log something here?
      person_id
    end

    # TODO: Not sure why, but this helper function is not being called...
    # Used by the gallery view
    def collection_thumbnail(_document, _image_options = {}, _url_options = {})
      #content_tag(:span, "", class: [Hyrax::ModelIcon.css_class_for(Collection), "collection-icon-search"])
      #image_tag("project_logo.jpg")
      #byebug
      content_tag(:span, "project", class: ["collection-icon-search"])
    end

    def person_doc(person_id)
      # TODO: error handling if person can't be found or there's more than 1 doc
      select_result = Blacklight.default_index.connection.select(params: { q: "*:*", fq: "id:#{person_id}" })
      person_doc = select_result['response']['docs'].first
    end

    def preferred_name(person_doc)
      person_doc[Solrizer.solr_name('preferred_name')].first
    end
end

