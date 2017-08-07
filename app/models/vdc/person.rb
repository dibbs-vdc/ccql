class Vdc::Person < ActiveFedora::Base

  # TODO: How much of this needs to be searchable? 
  #       For now, excluding vdc_type, identifier_system

  # E.g., "Person", "Resource", "Tool", etc.
  property :vdc_type, predicate: ::RDF::Vocab::DC.type, multiple: false
  property :identifier_system, predicate: ::RDF::Vocab::DC.identifier, multiple: false
  
  property :orcid, predicate: ::RDF::Vocab::DC.identifier, multiple: false do |index|
    index.as :stored_searchable
  end

  property :preferred_name, predicate: ::RDF::Vocab::DC.title, multiple: false do |index|
    index.as :stored_searchable
  end

  # optional
  property :authoritative_name, predicate: ::RDF::Vocab::DC.title, multiple: false do |index|
    index.as :stored_searchable
  end

  # TODO: replace FIND_MAPPING below with actual mapping. (possibly set to ::RDF::Vocab::DC.identifier?)
  #property :authoritative_name_uri, predicate: FIND_MAPPING, multiple: false # Mandatory if authoritative_name exists

  property :edu_person_principal_name, predicate: ::RDF::Vocab::DC.identifier, multiple: false # mandatory with shibboleth login

  property :email, predicate: ::RDF::Vocab::DC.description, multiple: false do |index|
    index.as :stored_searchable
  end

  property :organization, predicate: ::RDF::Vocab::DC.description, multiple: false  do |index|
    index.as :stored_searchable
  end

  # optional
  property :department, predicate: ::RDF::Vocab::DC.description, multiple: false do |index|
    index.as :stored_searchable
  end

  property :position, predicate: ::RDF::Vocab::DC.description, multiple: false do |index|
    index.as :stored_searchable
  end

  property :discipline, predicate: ::RDF::Vocab::DC.subject, multiple: true do |index|
    index.as :stored_searchable
  end

  property :related_description, predicate: ::RDF::Vocab::DC.description, multiple: true # optional

  property :website, predicate: ::RDF::Vocab::DC.description, multiple: false # most likely optional
  property :cv, predicate: ::RDF::Vocab::DC.description, multiple: false # optional

  has_subresource "cv_upload"

  #belongs_to :book, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf

# TODO: 
#   There is some question on whether or not the current Person approach is too simplistic and/or hackish.
#   Do do we do a simplistic approach like above?
#     - If above, how do we create links?
#   Is there a better way? (Perhaps something that more closely compares to how "Works" are implemented)

  def create(user)
      # TODO: Add Person to Fedora
      # TODO: before saving, do some validation on the Person to make sure it's constructed properly
      p = Vdc::Person.new
      p.vdc_type = "Person"
      p.identifier_system = user.orcid # TODO: strip off anything unnecessary??
      p.orcid = RDF::URI(user.orcid)
      p.preferred_name = user.last_name + ", " + user.first_name
      # TODO: How do I populate p.authoritative_name and p.authoritative_name_uri

      #TODO: populate this via hidden field on registration form?
      #p.edu_person_principal_name = u.edu_person_principal_name

      p.email = u.email
      #p.organization = u.organization
      #p.organization = ( u.organization == "other" ) ? u.organization_other || u.organization
      # TODO: populate more Person data here.

      # TODO: attach cv if it exists with these instructions 
      # https://github.com/samvera/hydra/wiki/Lesson---Adding-attached-files
      # NOTE: I have no idea if this adheres to pcdm standards. 
      #p.cv_upload.content = File.open("YOUR_FILE_HERE")
      #p.cv_upload.mime_type = "application/pdf"
      #p.cv_upload.original_name = "SOMETHINGSOMETHINGDARKSIDE.pdf"
      #p.cv_upload.uri = "SOMETHING"

      # TODO: some validation here
      # TODO: only once you're ready... save
      #p.save
  end
end
