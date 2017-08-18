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

    # OPTIONAL
    self.terms += [:funder]
    self.terms += [:abstract]
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
