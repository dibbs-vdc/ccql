#TODO: I have no idea if this controller even makes sense. Where should I
#      put the approve_user method? Should it be a service?

module Hyrax
  class Admin::Vdc::PendingRegistrationsController < AdminController
    include Hyrax::Admin::UsersControllerBehavior
    
    before_action :ensure_admin!

    # TODO: Find a way to limit approval to admins only
    # TODO: should this be some sort of background job?
    def approve_user
      # TODO: error handling?
      user = ::User.find(params[:user_id])
      user.approved = true
      user.save

      #person = create_person_from_user(user)
      person = Vdc::UserToPersonSyncService.new({user: user}).create_person_from_user(user)

      # Now that we have the person id in Fedora, we can save it to user
      user.identifier_system = person.id
      user.save

      AdminMailer.new_user_approval(user).deliver
      redirect_to hyrax.admin_vdc_pending_registrations_path, notice: "Approved #{user.email}"
    end

    private

      def ensure_admin!
        # Only user authorized to read the admin dash can access this controller
        authorize! :read, :admin_dashboard
      end

  end
end
