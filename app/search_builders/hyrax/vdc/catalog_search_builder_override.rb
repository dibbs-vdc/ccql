# Attempting to override from Hyrax Gem 1.0.4:
#   app/search_builders/hyrax/catalog_search_builder.rb

module Hyrax
  module Vdc
    module CatalogSearchBuilderOverride

      # the {!lucene} gives us the OR syntax
      def new_query
        "{!lucene}#{interal_query(dismax_query)} #{interal_query(join_for_works_from_files)} #{interal_query(join_for_works_from_person)}"
      end

      # join from person id to work relationship via solrized person_ids_ssim
      def join_for_works_from_person
        "{!join from=#{ActiveFedora.id_field} to=person_ids_ssim}#{dismax_query}"
      end

    end
  end
end
