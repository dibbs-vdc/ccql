class VdcCreatorAttributeRenderer < Hyrax::Renderers::AttributeRenderer

  def label
    "Depositor"
  end

  def attribute_value_to_html(value)
    # NOTE: Modified from Hyrax Gem 1.0.4

    if microdata_value_attributes(field).present?
      "<span#{html_attributes(microdata_value_attributes(field))}>#{li_value_for_vdc_creator(value)}</span>"
    else
      li_value_for_vdc_creator(value)
    end
  end

  # value - Person id
  def li_value_for_vdc_creator(value)
    # TODO: general error handling

    select_result = Blacklight.default_index.connection.select(params: { q: "*:*", fq: "id:#{value}" })
    person_doc = select_result['response']['docs'].first

    buffer = ""
    br = "<br />".html_safe

    if person_doc.present?
      buffer << profile(person_doc) << br
      buffer << orcid(person_doc) << br
      buffer << organization(person_doc) << br
      buffer << email(person_doc) << br
      buffer << department(person_doc) << br
      buffer << position(person_doc) << br
      buffer << discipline(person_doc) << br
      buffer << br
    end
    buffer
  end

  def profile(person_doc)
    name = person_doc[Solrizer.solr_name('preferred_name')].first
    user = User.find_by(identifier_system: person_doc['id'])
    if user.present?
      link_to name, Hyrax::Engine.routes.url_helpers.user_path(user)
    else
      "User not present"
    end
  end

  def orcid(person_doc)
    # TODO: Find out why orcid isn't in select_result?
    # orcid = link_to(ERB::Util.h(person.orcid.to_uri.to_s), person.orcid.to_uri.to_s)
    user = User.find_by(identifier_system: person_doc['id'])

    return '' unless user && user.orcid
    link_to(user.orcid, user.orcid)
  end

  def organization(person_doc)
    person_doc[Solrizer.solr_name('organization')]&.first || ''
  end

  def email(person_doc)
    person_doc[Solrizer.solr_name('email')]&.first || ''
  end

  def department(person_doc)
    "Department: #{person_doc[Solrizer.solr_name('department')]&.first}"
  end

  def position(person_doc)
    "Position: #{person_doc[Solrizer.solr_name('position')]&.first&.capitalize}"
  end

  def discipline(person_doc)
    "Discipline(s): #{person_doc[Solrizer.solr_name('discipline')]&.join(', ')}"
  end

end
