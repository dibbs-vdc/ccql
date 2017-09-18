# Modified from Hyrax Gem 1.0.2
#   index: add approved where clause
#   edit: temporarily to turn off edit functionality until we're ready to put it back
#   update: temporarily to turn off edit functionality until we're ready to put it back

module Hyrax
  class UsersController < ApplicationController
    include Hyrax::UsersControllerBehavior
    
    def index
      @users = search(params[:uq]).where(approved: true)
    end

    def edit
      # TODO: put functionality back eventually
      flash[:notice] = "Profile editing has been temporarily disabled."
      @trophies = []
    end

    def update
      # TODO: put functionality back eventually
      flash[:notice] = "Profile updating has been temporarily disabled."
    end    

  end
end
