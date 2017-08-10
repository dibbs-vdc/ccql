# Generated via
#  `rails generate hyrax:work Vdc::Resource`
class Vdc::Resource < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  
  #self.human_readable_type = 'Vdc/Resource'
  self.human_readable_type = 'Resource'

  property :vdc_type, predicate: ::RDF::Vocab::DC.type, multiple: false do |index|
    index.as :stored_searchable # TODO: Should this be searchable?
  end  

  property :identifier_system, predicate: ::RDF::Vocab::DC.identifier, multiple: false 

  property :identifier_doi, predicate: ::RDF::Vocab::DC.identifier, multiple: false do |index|
    index.as :stored_searchable # TODO: Should this be searchable?
  end  

  # NOTE: :creator already exists (::RDF::Vocab::DC11.creator, multiple: true)
  #       http://samvera.github.io/customize-metadata-model.html#basic-metadata

  property :authoritative_name, predicate: ::RDF::Vocab::DC11.creator, multiple: false do |index|
    index.as :stored_searchable
  end

  property :authoritative_name_uri, predicate: ::RDF::Vocab::DC.type, multiple: false do |index|
    index.as :stored_searchable
  end

  # NOTE: :title already exists as core metadata (default is multiple, which needs to be turned off in the form)
  #       http://samvera.github.io/customize-metadata-model.html#core-metadata

  property :genre, predicate: ::RDF::Vocab::DC.type, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  # NOTE: :description (for abstract) already exists as basic metadata (default is multiple, which needs to be turned off in the form)
  #       However, I'm deleting it in favor of :abstract
  #       http://samvera.github.io/customize-metadata-model.html#basic-metadata

  property :abstract, predicate: ::RDF::Vocab::DC.description, multiple: false do |index|
    index.as :stored_searchable
  end

  property :funder, predicate: ::RDF::Vocab::DC.contributor, multiple: true do |index|
    index.as :stored_searchable
  end

  property :research_problem, predicate: ::RDF::Vocab::DC11.description, multiple: false do |index|
    index.as :stored_searchable
  end

  property :note, predicate: ::RDF::Vocab::DC11.description, multiple: true do |index|
    index.as :stored_searchable
  end

  property :readme, predicate: ::RDF::Vocab::DC11.description, multiple: true do |index|
    index.as :stored_searchable
  end

  # NOTE: :date_created (for creationDate) already exists as basic metadata (default is multiple, which needs to be turned off in the form)
  #       http://samvera.github.io/customize-metadata-model.html#basic-metadata

  # TODO: Is this searchable?
  property :extent, predicate: ::RDF::Vocab::DC.extent, multiple: false

  # TODO: Is this searchable?
  property :format, predicate: ::RDF::Vocab::DC.format, multiple: true

  property :coverage_spatial, predicate: ::RDF::Vocab::DC.coverage, multiple: true do |index|
    index.as :stored_searchable
  end

  property :coverage_temporal, predicate: ::RDF::Vocab::DC.coverage, multiple: true do |index|
    index.as :stored_searchable
  end

  # NOTE: :license already exists as basic metadata (default is multiple, which needs to be turned off in the form)
  #       http://samvera.github.io/customize-metadata-model.html#basic-metadata
  # TODO: Does this map appropriately to what VDC wants?

  
end
