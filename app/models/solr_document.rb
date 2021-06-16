# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior


  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.

  use_extension( Hydra::ContentNegotiation )

  def parent
    OpenStruct.new(id: self['parent_ssi'])
  end

  def usage_count
    fetch(Solrizer.solr_name('usage_count', :displayable, type: :integer), 0)
  end

  def usage_purposes
    fetch(Solrizer.solr_name('usage_purposes', :facetable), [])
  end

  def vdc_type
    self[Solrizer.solr_name('vdc_type')]
  end

  def vdc_creator
    self[Solrizer.solr_name('vdc_creator')]
  end

  def vdc_title
    self[Solrizer.solr_name('vdc_title')]
  end

  def creation_date
    self[Solrizer.solr_name('creation_date')] || self["creation_date_sim"]
  end

  def authoritative_name
    self[Solrizer.solr_name('authoritative_name')]
  end

  def authoritative_name_uri
    self[Solrizer.solr_name('authoritative_name_uri')]
  end

  def genre
    self[Solrizer.solr_name('genre')]
  end

  def funder
    self[Solrizer.solr_name('funder')]
  end

  def note
    self[Solrizer.solr_name('note')]
  end

  def extent
    self[Solrizer.solr_name('extent')]
  end

  def format
    self[Solrizer.solr_name('format')]
  end

  def coverage_spatial
    self[Solrizer.solr_name('coverage_spatial')]
  end

  def coverage_temporal
    self[Solrizer.solr_name('coverage_temporal')]
  end

  def vdc_license
    self[Solrizer.solr_name('vdc_license')]
  end

  def collection_size
    self[Solrizer.solr_name('collection_size')]
  end

  def discipline
    self[Solrizer.solr_name('discipline')]
  end

  def preferred_name
    self[Solrizer.solr_name('preferred_name')]
  end

  def organization
    self[Solrizer.solr_name('organization')]
  end

  def relation_uri
    self[Solrizer.solr_name('relation_uri')]
  end

  def relation_type
    self[Solrizer.solr_name('relation_type')]
  end

  # NOTE: If I don't return nil on empty single-valued fields, they'll be displayed.
  #       It's more desirable to not display empty fields.
  # TODO: There's got to be a better way to do this. I haven't figured it out yet.
  def identifier_doi
    doi = self[Solrizer.solr_name('identifier_doi')]
    return nil if doi.nil? || doi.first.empty?
    doi
  end

  def readme_abstract
    ra = self[Solrizer.solr_name('readme_abstract')]
    return nil if ra.nil? || ra.first.empty?
    ra
  end

  def abstract
    a = self[Solrizer.solr_name('abstract')]
    return nil if a.nil? || a.first.empty?
    a
  end

  def research_problem
    rp = self[Solrizer.solr_name('research_problem')]
    return nil if rp.nil? || rp.first.empty?
    rp
  end

end
