module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

    # *Sometimes* a Blacklight index field helper_method
    # @param [String,User,Hash{Symbol=>Array}] args if a hash, the user_key must be under :value
    # @return [ActiveSupport::SafeBuffer] the html_safe link
    def link_to_person(args)
      #user_or_key = args.is_a?(Hash) ? args[:value].first : args
      #user = case user_or_key
      #       when User
      #         user_or_key
      #       when String
      #         ::User.find_by_user_key(user_or_key)
      #       edn
      #return user_or_key if user.nil?
      #text = user.respond_to?(:name) ? user.name : user_or_key
      #link_to text, Hyrax::Engine.routes.url_helpers.profile_path(user)

      key = args[:document][args[:field]]

      # TODO: find a way to replace this lookup via solr instead... fedora lookups are supposedly expensive
      # TODO: error handling if person can't be found or there's more than 1 key
      person = ::Vdc::Person.find(key.first) #
      text = person.preferred_name
      link_to text, main_app.search_catalog_path(search_state.add_facet_params_and_redirect(Solrizer.solr_name("vdc_creator", :facetable), key.first))
    rescue URI::InvalidURIError
      text = key.first
      text
    end

end
