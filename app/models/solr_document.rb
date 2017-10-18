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

  def collection_size
    self[Solrizer.solr_name('collection_size')]
  end

  def discipline
    self[Solrizer.solr_name('discipline')]
  end

  # NOTE: If I don't return nil on empty single-valued fields, they'll be displayed.
  #       It's more desirable to not display empty fields.
  def identifier_doi
    doi = self[Solrizer.solr_name('identifier_doi')]
    return nil if doi.first.empty?
    doi
  end

  def readme_abstract
    ra = self[Solrizer.solr_name('readme_abstract')]
    return nil if ra.first.empty?
    ra
  end

  def abstract
    a = self[Solrizer.solr_name('abstract')]
    return nil if a.first.empty?
    a
  end

  def research_problem
    rp = self[Solrizer.solr_name('research_problem')]
    return nil if rp.first.empty?
    rp
  end


end
