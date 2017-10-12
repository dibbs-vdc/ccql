# TODO: This probably shouldn't be a faceted renderer anymore... (It started out as one)
class VdcCreatorAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  def label
    "Creator (VDC)"
  end

  def attribute_value_to_html(value) 
    # NOTE: Modified from Hyrax Gem 1.0.4

    if microdata_value_attributes(field).present?
      "<span#{html_attributes(microdata_value_attributes(field))}>#{li_value_for_vdc_creator(value)}</span>"
    else
      li_value_for_vdc_creator(value)
    end
  end

  def li_value_for_vdc_creator(value)
    # TODO: find a way to replace this lookup via solr instead... fedora lookups are supposedly expensive
    # TODO: error handling if person can't be found or there's more than 1 key
    # TODO: general error handling
    # TODO: Find a way to componentize this an use it for other things eventually. 

    # NOTE: This is being viewed from the long display. It might be nice to put this in the short display too.
    #byebug
    person = ::Vdc::Person.find(value)
    name = "#{person.preferred_name}"
    user = User.find_by(identifier_system: person.id)
    profile = link_to name, Hyrax::Engine.routes.url_helpers.profile_path(user)
    orcid = link_to(ERB::Util.h(person.orcid.to_uri.to_s), person.orcid.to_uri.to_s)
    organization = "#{person.organization}"
    email = "#{person.email}"
    department = "Department: #{person.department}"
    position = "Position: #{person.position}"
    discipline = "Discipline(s): #{person.discipline.map(&:inspect).reject(&:blank?).join(', ').gsub('"', '')}"
    id = "ID: #{person.id}"
    br = "<br />".html_safe

    profile+br+orcid+br+organization+br+email+br+department+br+position+br+discipline+br+id
  end
end
