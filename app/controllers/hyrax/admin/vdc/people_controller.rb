module Hyrax
  module Admin
    class Vdc::PeopleController < ApplicationController
      before_action :ensure_admin!

      # TODO: Should I just remove this?
      def new
        self.vdc_type = "Person"
      end

      # TODO: should this be some sort of background job?
      # TODO: error handling?
      def create
        user = ::User.find(params[:user_id])
        person = ::Vdc::UserToPersonSyncService.new({user: user}).create_person_from_user(user)
        redirect_to hyrax.admin_users_path, notice: "Created Person #{user.email}"
      end
  
      # TODO: should this be some sort of background job?
      # TODO: error handling?
      def update
        user = ::User.find(params[:user_id])
        person = ::Vdc::UserToPersonSyncService.new({user: user}).update_person_from_user(user)
        AdminMailer.updated_person_admin_notification(user).deliver
        redirect_to hyrax.admin_users_path, notice: "Updated Person #{user.email}. Email notification sent to admin."
      end

      def show
        id = params[:id]
        @person = ::Vdc::Person.find(id)
      rescue Ldp::Gone
        flash[:notice] = "This person (#{id}) no longer exists, and the linked data pointer is gone."
        redirect_to admin_vdc_people_path
        #TODO: What other errors should I be catching here?
      end

      def index
        # TODO: Is there a better way to populate all of the people? 
        #       Eventually index and look up from solr?
        @people = ::Vdc::Person.all
      end

      #def delete(user)
      #end

      #def edit
      #  super
      #end

      def destroy
        @person = ::Vdc::Person.find(params[:id])
        @user = ::User.where(identifier_system: @person.id).first
        # TODO: raise exception if user or person is not found
        @person.destroy!
        if @user != nil
          @user.identifier_system = nil
          @user.save
        end
        # TODO: Gotta find out how to put this in a transaction....
 
        redirect_to admin_vdc_people_path
      rescue Ldp::Gone
        flash[:notice] = "This person (#{params[:id]}) no longer exists, and the linked data pointer is gone."
        redirect_to admin_vdc_people_path
        #TODO: What other errors should I be catching here?
      end

      private

        def ensure_admin!
          # Only user authorized to read the admin dash can access this controller
          authorize! :read, :admin_dashboard
        end

    end
  end
end
