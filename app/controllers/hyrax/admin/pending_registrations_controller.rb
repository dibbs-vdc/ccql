#TODO: I have no idea if this controller even makes sense. Where should I
#      put the approve_user method?

module Hyrax
  class Admin::PendingRegistrationsController < AdminController
    include Hyrax::Admin::UsersControllerBehavior
    
    # TODO: Find a way to limit approval to admins only
    def approve_user
      # TODO: error handling?
      user = ::User.find(params[:user_id])
      user.approved = true
      user.save

      redirect_to hyrax.admin_pending_registrations_path, notice: "Approved #{user.email}"
    end
  end
end
