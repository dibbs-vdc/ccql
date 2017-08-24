# Generated via
#  `rails generate hyrax:work Vdc::Resource`
module Hyrax
  class Vdc::ResourceForm < Hyrax::Forms::WorkForm
    self.model_class = ::Vdc::Resource

    #####
    # Defaults fields to be KEPT in the VDC Resource
    #   creator
    #   title (assigned to vdc_title by the vdc resource actor)
    #   date_created # TODO: Can this be used instead of date?
    #   license # TODO: Can this be used for VDC purposes?

    #####
    # New fields to be ADDED to the VDC Resource

    self.required_fields += [:vdc_creator]
    self.terms += [:vdc_creator]
    self.required_fields += [:genre]
    self.terms += [:genre]

    # Removing default term for ordering fields on the form.
    # Default ones appear first.
    # These fields will be put back later in the order
    # that we want them to appear.
    # TODO: I'm sure there's a better way to do this?
    #       Maybe in the toggle javascript, make sure that
    #       I don't move whole form groups? Instead, just move
    #       children elements between option and required form groups?
    self.terms -= [:rights]
    self.terms -= [:date_created]

    # OPTIONAL/REQUIRED (depending on visibility)
    # We want these to come first so that when they change position
    # from required
    self.terms += [:abstract]

    # OPTIONAL
    self.terms += [:rights]
    self.terms += [:date_created]
    self.terms += [:funder]
    self.terms += [:research_problem]
    self.terms += [:note]
    self.terms += [:coverage_spatial]
    self.terms += [:coverage_temporal]
    self.terms += [:identifier_doi]

    # TODO: Relationships and their UI need to be discussed more before potentially adding this back in.
    #self.terms += [:relation] # TODO
    #self.terms += [:relation_url] # TODO
    #self.terms += [:relation_type] # TODO

    #####
    # Default fields to be REMOVED from the VDC Resource
    self.required_fields -= [:keyword]
    self.required_fields -= [:rights]
    self.required_fields -= [:creator]
    self.terms -= [:keyword]
    self.terms -= [:creator]
    self.terms -= [:contributor]
    self.terms -= [:publisher]
    self.terms -= [:subject]
    self.terms -= [:language]
    self.terms -= [:identifier]
    self.terms -= [:based_near]
    self.terms -= [:related_url]
    self.terms -= [:source]
    self.terms -= [:description] # Removed in favor of :abstract

    # Make title non-repeatable (single-value)
    # TODO: I'm not sure why both the self.multiple? and multiple? 
    #       I need to investigate to see if this is a Hyrax bug.
    def self.multiple?(field)
      if [:title].include? field.to_sym
        false
      else
        super
      end
    end
    def multiple?(field)
      if [:title].include? field.to_sym
        false
      else
        super
      end
    end

    # Cast back to multi-value when saving
    def self.model_attributes(_)
      attrs = super
      attrs[:title] = Array(attrs[:title]) if attrs[:title]
      attrs
    end

    def title
      super.first || ""
    end
  end
end
