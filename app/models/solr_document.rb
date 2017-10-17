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

  def vdc_type
    self[Solrizer.solr_name('vdc_type')]
  end

  def identifier_doi
    self[Solrizer.solr_name('identifier_doi')]
  end

  def vdc_creator
    self[Solrizer.solr_name('vdc_creator')]
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

  def abstract
    self[Solrizer.solr_name('abstract')]
  end

  def funder
    self[Solrizer.solr_name('funder')]
  end

  def research_problem
    self[Solrizer.solr_name('research_problem')]
  end

  def note
    self[Solrizer.solr_name('note')]
  end

  def readme_abstract
    self[Solrizer.solr_name('readme_abstract')]
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

  def collection_size
    self[Solrizer.solr_name('collection_size')]
  end

  def discipline
    self[Solrizer.solr_name('discipline')]
  end

end
