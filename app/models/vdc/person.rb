# TODO: 
#   There is some question on whether or not the current Person approach is too simplistic and/or hackish.
#   Do do we do a simplistic approach defined below?
#   Is there a better way? (Perhaps something that more closely compares to how "Works" are implemented)

class Vdc::Person < ActiveFedora::Base

  # TODO: How much of this needs to be searchable? 
  #       For now, excluding vdc_type, identifier_system

  # E.g., "Person", "Resource", "Tool", etc.
  property :vdc_type, predicate: ::RDF::Vocab::DC.type, multiple: false
  
  # :identifier_system will be the :id
  property :identifier_system, predicate: ::RDF::Vocab::DC.identifier, multiple: false
  
  property :orcid, predicate: ::RDF::Vocab::DC.identifier, multiple: false do |index|
    index.as :stored_searchable
  end

  property :preferred_name, predicate: ::RDF::Vocab::DC.title, multiple: false do |index|
    index.as :stored_searchable
  end

  # Optional
  property :authoritative_name, predicate: ::RDF::Vocab::DC.title, multiple: false do |index|
    index.as :stored_searchable
  end

  # Mandatory if authoritative_name exists
  property :authoritative_name_uri, predicate: FIND_MAPPING, multiple: false do |index|
    index.as :stored_searchable
  end

  # Mandatory with Shibboleth login
  property :edu_person_principal_name, predicate: ::RDF::Vocab::DC.identifier, multiple: false do |index|
    index.as :stored_searchable
  end

  property :email, predicate: ::RDF::Vocab::DC.description, multiple: false do |index|
    index.as :stored_searchable
  end

  property :organization, predicate: ::RDF::Vocab::DC.description, multiple: false  do |index|
    index.as :stored_searchable
  end

  # Optional
  property :department, predicate: ::RDF::Vocab::DC.description, multiple: false do |index|
    index.as :stored_searchable
  end

  property :position, predicate: ::RDF::Vocab::DC.description, multiple: false do |index|
    index.as :stored_searchable
  end

  property :discipline, predicate: ::RDF::Vocab::DC.subject, multiple: true do |index|
    index.as :stored_searchable
  end

  # Optional
  property :related_description, predicate: ::RDF::Vocab::DC.description, multiple: true do |index|
    index.as :stored_searchable
  end

  # Optional
  property :website, predicate: ::RDF::Vocab::DC.description, multiple: false do |index|
    index.as :stored_searchable
  end 

  # Link to a document stored in either Fedora or externally 
  # If the cv is stored within Fedora, the cv_upload will be set.
  property :cv, predicate: ::RDF::Vocab::DC.description, multiple: false # optional
  has_subresource "cv_upload"

  # TODO: Does a Vdc::Person belong to a Vdc::Resource? Or, is it the opposite?
  belongs_to :resource, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf
  belongs_to :resource, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isReplacedBy
  # TODO: Flesh out more belongs_to relationship

  # TODO: Get Person objects indexed in Solr

  def create(user)
      # TODO: Add Person to Fedora
      # TODO: before saving, do some validation on the Person to make sure it's constructed properly
      p = Vdc::Person.new
      p.vdc_type = "Person"
      p.orcid = RDF::URI(user.orcid)
      p.preferred_name = user.last_name + ", " + user.first_name

      # TODO: How do I populate p.authoritative_name and p.authoritative_name_uri
      #       Currently, left blank.

      #TODO: populate this via hidden field on registration form?
      #p.edu_person_principal_name = u.edu_person_principal_name

      p.email = u.email
      p.organization = u.organization
      #p.organization = ( u.organization == "other" ) ? u.organization_other || u.organization
      # TODO: populate more Person data here.

      # TODO: attach cv if it exists with these instructions 
      # https://github.com/samvera/hydra/wiki/Lesson---Adding-attached-files
      # NOTE: I have no idea if this adheres to pcdm standards. 
      #p.cv_upload.content = File.open("/home/vdc/rails_apps/ccql/README.md")
      #p.cv_upload.mime_type = "application/text"
      #p.cv_upload.original_name = "README.md"

      # TODO: some validation here
      # TODO: only once you're ready... save
      #p.save

      # Once this person has been saved, then perform some additional operations
      #p.identifier_system = p.id # set system identifier once it's been generated.
      #p.cv = RDF::URI(p.cv_upload.uri) # set only after the cv_upload has been saved to fedora
      #p.save
  end

  def delete(user)
  end

end
