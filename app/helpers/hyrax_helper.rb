module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

    # *Sometimes* a Blacklight index field helper_method
    # @param [String,User,Hash{Symbol=>Array}] args if a hash, the user_key must be under :value
    # @return [ActiveSupport::SafeBuffer] the html_safe link
    def link_to_person(args)
      key = args[:document][args[:field]]

      # TODO: find a way to replace this lookup via solr instead... fedora lookups are supposedly expensive
      # TODO: error handling if person can't be found or there's more than 1 key
      person = ::Vdc::Person.find(key.first) #
      text = person.preferred_name
      text
      #link_to text, main_app.search_catalog_path(search_state.add_facet_params_and_redirect(Solrizer.solr_name("vdc_creator", :facetable), key.first))
    rescue URI::InvalidURIError
      text = key.first
      text
    rescue Ldp::Gone
      text = "Person no longer exists (#{key.first})"
      text
    end

    def link_to_person_profile(args)
      key = args[:document][args[:field]]

      # TODO: find a way to replace this lookup via solr instead... fedora lookups are supposedly expensive
      # TODO: error handling if person can't be found or there's more than 1 key
      person = ::Vdc::Person.find(key.first) #
      text = person.preferred_name
      user = User.find_by(identifier_system: person.id)
      link_to text, Hyrax::Engine.routes.url_helpers.profile_path(user)
    rescue URI::InvalidURIError
      text = key.first
      text
    rescue Ldp::Gone
      text = "Person no longer exists (#{key.first})"
      text
    end

    # TODO: Not sure why, but this helper function is not being called...
    # Used by the gallery view                                                                                                                                             
    def collection_thumbnail(_document, _image_options = {}, _url_options = {})
      #content_tag(:span, "", class: [Hyrax::ModelIcon.css_class_for(Collection), "collection-icon-search"])                                                                
      #image_tag("project_logo.jpg")                                                                                                                                        
      #byebug
      content_tag(:span, "project", class: ["collection-icon-search"])
    end

end

