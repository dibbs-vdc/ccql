# Generated via
#  `rails generate hyrax:work Vdc::Resource`
module Hyrax
  class Vdc::ResourceForm < Hyrax::Forms::WorkForm
    include ::Vdc::VdcCreatorForSelect

    self.model_class = ::Vdc::Resource

    #####
    # Defaults fields to be KEPT in the VDC Resource
    #   creator
    #   title (assigned to vdc_title by the vdc resource actor)

    # Removing default term for ordering fields on the form.
    # Default ones appear first.
    # These fields will be put back later in the order
    # that we want them to appear.
    # TODO: I'm sure there's a better way to do this?
    #       Maybe in the toggle javascript, make sure that
    #       I don't move whole form groups? Instead, just move
    #       children elements between option and required form groups?
    self.terms -= [:date_created]

    #####
    # New fields to be ADDED to the VDC Resource

    self.required_fields += [:vdc_creator]
    self.terms += [:vdc_creator]
    self.required_fields += [:genre]
    self.terms += [:genre]
    self.terms += [:research_problem]

    # OPTIONAL/REQUIRED (depending on visibility)
    # We want these to come first so that when they change position
    # from required
    self.terms += [:abstract]

    # OPTIONAL
    self.terms -= [:license]
    self.terms += [:vdc_license]
    self.terms += [:funder]
    self.terms += [:note]
    self.terms += [:discipline]
    self.terms += [:coverage_spatial]
    self.terms += [:coverage_temporal]
    self.terms += [:relation_type]
    self.terms += [:relation_uri]
    self.terms += [:readme_abstract]

    #####
    # Default fields to be REMOVED from the VDC Resource
    self.required_fields -= [:keyword]
    self.required_fields -= [:rights_statement]
    self.required_fields -= [:creator]
    self.terms -= [:keyword]
    self.terms -= [:rights_statement]
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
