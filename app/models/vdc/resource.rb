# Generated via
#  `rails generate hyrax:work Vdc::Resource`
class Vdc::Resource < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  self.indexer = ResourceIndexer

  # The following are validations for the resource work, regardless of what
  # visibility is selected. Form-level validations will also exist for those
  # that do change based on visibility.
  validates :title, presence: { message: 'Your resource must have a title.' }

  #self.human_readable_type = 'Vdc/Resource'
  self.human_readable_type = 'Resource'

  property :vdc_type, predicate: ::RDF::URI("https://datacollaboratory.org/resource#vdcType"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :identifier_system, predicate: ::RDF::URI("https://datacollaboratory.org/resource#identifierSystem"), multiple: false do |index|
    index.as :stored_searchable
  end

  property :identifier_doi, predicate: ::RDF::URI("https://datacollaboratory.org/resource#identifierDoi"), multiple: false do |index|
    index.as :stored_searchable, :facetable # TODO: Should this be searchable?
  end

  property :vdc_creator, predicate: ::RDF::URI("https://datacollaboratory.org/resource#creator"), multiple: true do |index|
    index.as :stored_searchable, :facetable # TODO: Should this be searchable?
  end

  property :authoritative_name, predicate: ::RDF::URI("https://datacollaboratory.org/person#authoritativeName"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :authoritative_name_uri, predicate: ::RDF::URI("https://datacollaboratory.org/person#authoritativeNameUri"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  # NOTE: :title already exists as core metadata (default is multiple, which needs to be turned off in the form)
  #       http://samvera.github.io/customize-metadata-model.html#core-metadata
  #       The pre-existing title must exist, but we'll create an additional
  #       :vdc_title mapped to a different predicate in post-processing.

  # To be set from :title in post processing
  property :vdc_title, predicate: ::RDF::URI("https://datacollaboratory.org/resource#title"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :genre, predicate: ::RDF::URI("https://datacollaboratory.org/resource#genre"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  # NOTE: :description (for abstract) already exists as basic metadata (default is multiple)
  #       However, I'm deleting it in favor of :abstract with our own predicate
  #       http://samvera.github.io/customize-metadata-model.html#basic-metadata

  property :abstract, predicate: ::RDF::URI("https://datacollaboratory.org/resource#abstract"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :funder, predicate: ::RDF::URI("https://datacollaboratory.org/resource#funder"), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :research_problem, predicate: ::RDF::URI("https://datacollaboratory.org/resource#researchProblem"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :note, predicate: ::RDF::URI("https://datacollaboratory.org/resource#note"), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :readme_file, predicate: ::RDF::URI("https://datacollaboratory.org/resource#readmeFile"), multiple: false do |index|
    index.as :stored_searchable
  end

  # TODO: Find out if there's a better way to get readme_file_ids_from_form,
  #       other than using a property from the resource model. Seems like there
  #       should be. It's used in the resources form and vdc/resources_controller.rb
  property :readme_file_ids_from_form, predicate: ::RDF::URI("https://datacollaboratory.org/resource#readmeFileIdsFromForm"), multiple: false do |index|
    index.as :stored_searchable
  end

  property :readme_abstract, predicate: ::RDF::URI("https://datacollaboratory.org/resource#readmeAbstract"), multiple: false do |index|
    index.as :stored_searchable
  end

  property :creation_date, predicate: ::RDF::URI("https://datacollaboratory.org/resource#creationDate"), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :extent, predicate: ::RDF::URI("https://datacollaboratory.org/resource#extent"), multiple: false

  property :format, predicate: ::RDF::URI("https://datacollaboratory.org/resource#format"), multiple: true

  property :discipline, predicate: ::RDF::URI("https://datacollaboratory.org/resource#discipline"), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :coverage_spatial, predicate: ::RDF::URI("https://datacollaboratory.org/resource#coverageSpatial"), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :coverage_temporal, predicate: ::RDF::URI("https://datacollaboratory.org/resource#coverageTemporal"), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  #property :is_referenced_by_uri, predicate: ::RDF::Vocab::DC.isReferencedBy, multiple: true do |index|
  #  index.as :stored_searchable
  #end

  property :relation_uri, predicate: ::RDF::URI("https://datacollaboratory.org/resource#relationUri"), multiple: true do |index|
    index.as :stored_searchable
  end

  property :relation_type, predicate: ::RDF::URI("https://datacollaboratory.org/resource#relationType"), multiple: true do |index|
    index.as :stored_searchable
  end

  property :vdc_license, predicate: ::RDF::URI("https://datacollaboratory.org/resource#license"), multiple: false do |index|
    index.as :stored_searchable
  end

  # The include (include ::Hyrax::BasicMetadata) must appear
  # below custom predicate definitions as of Hyrax 2.0.0
  include ::Hyrax::BasicMetadata


  def vdc_creator(*args)
    value = get_values(:vdc_creator, *args)
    value.sort.map { |v| v.split.last }
  end

  def vdc_creator=(value)
    value = value.map.with_index { |v, i| "#{i} #{v}"}
    set_value(:vdc_creator, value)
  end

  def vdc_usages
    @vdc_usages ||= Vdc::Usage.where(work_gid: self.to_global_id.to_s)
  end
end
