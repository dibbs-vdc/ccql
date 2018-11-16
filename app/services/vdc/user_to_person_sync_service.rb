# Service to create and update a Fedora Person object, given a user.

# TODO: Get rid of all the repetition please...
# TODO: Put the admin restrictions in here in addition to the controllers?

class Vdc::UserToPersonSyncService
  ##
  # @!attribute [rw] user
  #   @return [::User]
  attr_accessor :user

  def initialize(user:)
    self.user = user
  end

  def create_person_from_user(*)
    # TODO: Understand how transactions work in Fedora and
    #       make sure it's being done properly here.
    # TODO: before saving, do some validation on the Person to make sure it's constructed properly

    p  = ::Vdc::Person.new(id: SecureRandom.uuid)
    p.identifier_system = p.id
    p.vdc_type          = p.class::VDC_TYPE

    p.orcid = person_orcid(user)
    p.preferred_name = person_preferred_name(user)

    # TODO: How do I auto-populate p.authoritative_name and p.authoritative_name_uri?
    #       Currently, left blank.
    # p.authoritative_name = ?
    # p.authoritative_name_uri = ?

    p.edu_person_principal_name = user.edu_person_principal_name
    p.email = user.email
    p.organization = person_organization(user)
    p.department = user.department
    p.position = person_position(user)
    p.discipline = person_discipline(user)
    p.website = person_website(user)
    p.cv = person_cv(user)
    p.related_description = person_related_description(user)

    p.save

    # Now that we have the person id in Fedora, we can save it to user
    user.identifier_system = p.id
    user.save

    p
  end

  def update_person_from_user(user)
    # TODO: before saving, do some validation on the Person to make sure it's constructed properly
    p = ::Vdc::Person.find(user.identifier_system)
    if p.nil?
      flash[:error] = "This person (#{user.identifier_system}) does not exist."
      return
    end

    p.orcid = person_orcid(user)
    p.preferred_name = person_preferred_name(user)

    # TODO: How do I auto-populate p.authoritative_name and p.authoritative_name_uri?
    #       Currently, left blank.
    # p.authoritative_name = ?
    # p.authoritative_name_uri = ?

    p.edu_person_principal_name = user.edu_person_principal_name
    p.email = user.email
    p.organization = person_organization(user)
    p.department = user.department
    p.position = person_position(user)
    p.discipline = person_discipline(user)
    p.website = person_website(user)
    p.cv = person_cv(user)
    p.related_description = person_related_description(user)

    p.save
    p
  end

  def person_orcid(user)
    user.orcid.present? ? ::RDF::URI(user.orcid) : nil
  end

  def person_preferred_name(user)
    user.display_name
  end

  def person_organization(user)
    # TODO: This "other" should probably be a constant somewhere...
    # TODO: validation
    if user.organization.downcase == "other" then
      return user.organization_other
    else
      return user.organization
    end
  end

  def person_discipline(user)
    # NOTE: A side-effect of using the multi-select in the form for
    #       selecting disciplines is that there's always an empty string
    #       as one of the values. We'd like to not include that in
    #       the person.
    return user.discipline&.reject(&:empty?) || []
  end

  def person_position(user)
    if user.position.downcase == "other"
      return user.position_other
    else
      return user.position
    end
  end

  def person_website(user)
    if !user.website.nil? and !user.website.empty?
      # TODO: need some url parsing and validation.
      # return RDF::URI(user.website)
      unless user.website[/\Ahttp/]
         return "http://#{user.website}"
      end
    end
    return user.website
  end

  def person_cv(user)
    # https://github.com/samvera/hydra/wiki/Lesson---Adding-attached-files
    # TODO: Does not adhere to PCDM standards. Find a way to make this a pcdm object too.
    # TODO: some validation here needed
    if !user.cv_file.file.nil?
      file_url = user.cv_file.url
      return RDF::URI(file_url)
    elsif valid_site(user.cv_link)
      return user.cv_link
    end
    return nil
  end

  def person_related_description(user)
    potential_urls = [user.sites_open_science_framework_url, user.sites_researchgate_url,
                      user.sites_vivo_url, user.sites_institutional_repo_url,
                      user.sites_linkedin_url, user.sites_other_url]
    descriptions = []

    potential_urls.each do |purl|
      # TODO: Make this a ::RDF::URI(purl) if it's an acutally valid url,
      #       instead of a string. For now, I don't know of a good and
      #       comprehensive way to check for this.
      descriptions << purl if valid_site(purl)
    end
    return descriptions
  end

  def valid_site(site)
    return (!site.nil? and (site.gsub(/\s+/, '') != ''))
  end

end
