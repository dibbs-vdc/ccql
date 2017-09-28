class VdcCreatorAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  def label
    "Creator (VDC)"
  end

  def attribute_value_to_html(value) 
    # NOTE: Modified from Hyrax Gem 1.0.4

    # TODO: find a way to replace this lookup via solr instead... fedora lookups are supposedly expensive
    # TODO: error handling if person can't be found or there's more than 1 key
    person = ::Vdc::Person.find(value)
    name = person.preferred_name
    if microdata_value_attributes(field).present?
      "<span#{html_attributes(microdata_value_attributes(field))}>#{li_value_for_vdc_creator(name, value)}</span>"
    else
      li_value_for_vdc_creator(name, value)
    end
  end

  def li_value_for_vdc_creator(name, value)
    # NOTE: Modified from Hyrax Gem 1.0.4 app/renderers/hyrax/renderers/faceted_attribute_renderer.rb#li_value
    link_to(ERB::Util.h(name), search_path(value))
  end

end
