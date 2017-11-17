module Hyrax
  class Vdc::CollectionForm < Hyrax::Forms::CollectionForm
    include ::Vdc::VdcCreatorForSelect

    #####
    # Defaults fields to be KEPT in the Collection
    #   creator
    #   title (assigned to vdc_title by the collection actor)
    #   date_created # TODO: Can this be used instead of date?

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
    # New fields to be ADDED to the Collection

    self.required_fields += [:vdc_creator]
    self.terms += [:vdc_creator]
    self.required_fields += [:vdc_title]
    self.terms += [:vdc_title]
    self.required_fields += [:collection_size]
    self.terms += [:collection_size]

    # Putting old fields back in a certain order
    self.required_fields += [:date_created]
    self.terms += [:date_created]

    # OPTIONAL/REQUIRED (depending on visibility)
    # We want these to come first so that when they change position
    # from required
    self.terms += [:abstract]

    # OPTIONAL
    self.terms += [:funder]
    self.terms += [:note]

    #####
    # Default fields to be REMOVED from the Collection
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

    def primary_terms
       [:title,
        :vdc_creator,
        :collection_size,
        :date_created]
    end

    def secondary_terms
      [:abstract,
       :funder,
       :note]
    end

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
