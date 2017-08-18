#TODO: I have no idea if this controller even makes sense. Where should I
#      put the approve_user method?

module Hyrax
  class Admin::PendingRegistrationsController < AdminController
    include Hyrax::Admin::UsersControllerBehavior

    def create_person_from_user(user)
      # TODO: Add Person to Fedora
      # TODO: before saving, do some validation on the Person to make sure it's constructed properly
      p = ::Vdc::Person.new
      p.vdc_type = "Person"
      p.orcid = ::RDF::URI(user.orcid)
      p.preferred_name = user.last_name + ", " + user.first_name

      # TODO: How do I auto-populate p.authoritative_name and p.authoritative_name_uri?
      #       Currently, left blank.
      # p.authoritative_name = ?
      # p.authoritative_name_uri = ?

      p.edu_person_principal_name = user.edu_person_principal_name if user.edu_person_principal_name != nil

      p.email = user.email
      if user.organization.downcase == "other" then
        p.organization = user.organization_other
      else
        p.organization = user.organization
      end

      p.department = user.department
      p.position = user.position
      p.discipline = user.discipline
      p.website = user.website
      p.save

      # TODO: attach cv if it exists with these instructions 
      # https://github.com/samvera/hydra/wiki/Lesson---Adding-attached-files
      # NOTE: I have no idea if this adheres to pcdm standards. 
      #p.cv_upload.content = File.open("/home/vdc/rails_apps/ccql/README.md")
      #p.cv_upload.mime_type = "application/text"
      #p.cv_upload.original_name = "README.md"

      # TODO: some validation here
      # TODO: only once you're ready... save

      # Once this person has been saved, do post-processing
      p.identifier_system = p.id
      #p.cv = RDF::URI(p.cv_upload.uri) # set only after the cv_upload has been saved to fedora
      p.save
      p
    end

    def update_person_from_user(user)
      # TODO: Add Person to Fedora
      # TODO: before saving, do some validation on the Person to make sure it's constructed properly
      p = ::Vdc::Person.find(user.identifier_system)
      if p = nil
        #TODO: put some error message here?
        return
      end

      p.orcid = ::RDF::URI(user.orcid)
      p.preferred_name = user.last_name + ", " + user.first_name

      # TODO: How do I auto-populate p.authoritative_name and p.authoritative_name_uri?
      #       Currently, left blank.
      # p.authoritative_name = ?
      # p.authoritative_name_uri = ?

      p.edu_person_principal_name = user.edu_person_principal_name if user.edu_person_principal_name != nil

      p.email = user.email
      if user.organization.downcase == "other" then
        p.organization = user.organization_other
      else
        p.organization = user.organization
      end

      p.department = user.department
      p.position = user.position
      p.discipline = user.discipline
      p.website = user.website
      p.save

      # TODO: attach cv if it exists with these instructions 
      # https://github.com/samvera/hydra/wiki/Lesson---Adding-attached-files
      # NOTE: I have no idea if this adheres to pcdm standards. 
      #p.cv_upload.content = File.open("/home/vdc/rails_apps/ccql/README.md")
      #p.cv_upload.mime_type = "application/text"
      #p.cv_upload.original_name = "README.md"

      # TODO: some validation here
      # TODO: only once you're ready... save
      #p.save

      p
    end



    
    # TODO: Find a way to limit approval to admins only
    # TODO: should this be some sort of background job?
    def approve_user
      # TODO: error handling?
      user = ::User.find(params[:user_id])
      user.approved = true
      user.save

      person = create_person_from_user(user)

      # Now that we have the person id in Fedora, we can save it to user
      user.identifier_system = person.id
      user.save

      #TODO: Turn mailer back on!!!!
      #AdminMailer.new_user_approval(user).deliver
      redirect_to hyrax.admin_pending_registrations_path, notice: "Approved #{user.email}"
    end
  end
end
