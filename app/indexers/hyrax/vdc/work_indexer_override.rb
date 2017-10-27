module Hyrax
  module Vdc
    module WorkIndexerOverride

      def generate_solr_document
        super.tap do |solr_doc|
          solr_doc[Solrizer.solr_name('member_ids', :symbol)] = object.member_ids
          solr_doc[Solrizer.solr_name('member_of_collections', :symbol)] = object.member_of_collections.map(&:first_title)
          solr_doc[Solrizer.solr_name('member_of_collection_ids', :symbol)] = object.member_of_collections.map(&:id)
          Solrizer.set_field(solr_doc, 'generic_type', 'Work', :facetable)

          # This enables us to return a Work when we have a FileSet that matches
          # the search query.  While at the same time allowing us not to return Collections
          # when a work in the collection matches the query.          
          solr_doc[Solrizer.solr_name('file_set_ids', :symbol)] = solr_doc[Solrizer.solr_name('member_ids', :symbol)]
          
          # This is not the ideal way of doing this, but it's one interim way.
          # We'll query for the vdc_creator here and then add all of the "*_tesim" values straight into the work.
          # Where this fails is when a person's information gets updated, but it's not updated in the work solr_doc
          # TODO: Eventually, we'll have to modify the (catalog?) search builder for the work and make sure that person 
          # solr docs are searched as well.

          #vdc_creator_result = Blacklight.default_index.connection.select(params: { q: "*:*", fq: "id:#{object.vdc_creator}" })
          #vdc_creator_docs = vdc_creator_result['response']['docs'].map do |hash|
          #  ::SolrDocument.new(hash)
          #end         
          #vdc_creator_docs.each do |doc|
          #  doc.to_h.each do |key, val|
          #    ((solr_doc[key] ||= []) << val) if key.ends_with?('_tesim')
          #  end
          #end
          (solr_doc[Solrizer.solr_name('person_ids', :symbol)] ||= []) << object.vdc_creator
          byebug


          admin_set_label = object.admin_set.to_s
          solr_doc[Solrizer.solr_name('admin_set', :facetable)] = admin_set_label
          solr_doc[Solrizer.solr_name('admin_set', :stored_searchable)] = admin_set_label
        end
      end

    end
  end
end
