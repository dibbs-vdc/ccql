module Vdc
  class CatalogSearchBuilder < Hyrax::CatalogSearchBuilder
    VDC_SEARCH_CLASSES = [Vdc::Person].freeze

    ### BEGIN -- porterd from previous VDC "override" code, is this really necessary?
    # the {!lucene} gives us the OR syntax
    def new_query
      "{!lucene}#{interal_query(dismax_query)} #{interal_query(join_for_works_from_files)} #{interal_query(join_for_works_from_person)}"
    end

    # join from person id to work relationship via solrized person_ids_ssim
    def join_for_works_from_person
      "{!join from=#{ActiveFedora.id_field} to=person_ids_ssim}#{dismax_query}"
    end
    ### END -- porterd from previous VDC "override" code, is this really necessary?

    def models
      work_classes + collection_classes + VDC_SEARCH_CLASSES
    end
  end
end
