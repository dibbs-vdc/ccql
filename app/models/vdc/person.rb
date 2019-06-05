# TODO:
#   There is some question on whether or not the current Person approach is too simplistic and/or hackish.
#   Do do we do a simplistic approach defined below?
#   Is there a better way? (Perhaps something that more closely compares to how "Works" are implemented)

class Vdc::Person < ActiveFedora::Base
  VDC_TYPE = 'Person'

  # TODO: How much of this needs to be searchable?
  #       For now, excluding vdc_type, identifier_system

  # E.g., "Person", "Resource", "Tool", etc.
  property :vdc_type, predicate: ::RDF::URI("https://datacollaboratory.org/person#vdcType"), multiple: false

  # :identifier_system will be the :id
  property :identifier_system, predicate: ::RDF::URI("https://datacollaboratory.org/person#identifierSystem"), multiple: false

  property :orcid, predicate: ::RDF::URI("https://datacollaboratory.org/person#orcid"), multiple: false do |index|
    index.as :stored_searchable
  end

  property :preferred_name, predicate: ::RDF::URI("https://datacollaboratory.org/person#preferredName"), multiple: false do |index|
    index.as :stored_searchable
  end

  # Optional
  property :authoritative_name, predicate: ::RDF::URI("https://datacollaboratory.org/person#authoritativeName"), multiple: false do |index|
    index.as :stored_searchable
  end

  # Mandatory if authoritative_name exists
  property :authoritative_name_uri, predicate: ::RDF::URI("https://datacollaboratory.org/person#authoritativeNameUri"), multiple: false do |index|
    index.as :stored_searchable
  end

  # Mandatory with Shibboleth login
  property :edu_person_principal_name, predicate: ::RDF::URI("https://datacollaboratory.org/person#eduPersonPrincipalName"), multiple: false do |index|
    index.as :stored_searchable
  end

  property :email, predicate: ::RDF::URI("https://datacollaboratory.org/person#email"), multiple: false do |index|
    index.as :stored_searchable
  end

  property :organization, predicate: ::RDF::URI("https://datacollaboratory.org/person#organization"), multiple: false  do |index|
    index.as :stored_searchable
  end

  # Optional
  property :department, predicate: ::RDF::URI("https://datacollaboratory.org/person#department"), multiple: false do |index|
    index.as :stored_searchable
  end

  property :position, predicate: ::RDF::URI("https://datacollaboratory.org/person#position"), multiple: false do |index|
    index.as :stored_searchable
  end

  property :discipline, predicate: ::RDF::URI("https://datacollaboratory.org/person#discipline"), multiple: true do |index|
    index.as :stored_searchable
  end

  # Optional
  property :related_description, predicate: ::RDF::URI("https://datacollaboratory.org/person#relatedDescription"), multiple: true do |index|
    index.as :stored_searchable
  end

  # Optional
  property :website, predicate: ::RDF::URI("https://datacollaboratory.org/person#website"), multiple: false do |index|
    index.as :stored_searchable
  end

  # Link to a document stored in either Fedora or externally
  # If the cv is stored within Fedora, the cv_upload will be set.
  property :cv, predicate: ::RDF::URI("https://datacollaboratory.org/person#CV"), multiple: false # optional
  has_subresource "cv_upload"
end
