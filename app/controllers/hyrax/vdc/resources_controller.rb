# Generated via
#  `rails generate hyrax:work Vdc::Resource`

module Hyrax
  class Vdc::ResourcesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Vdc::Resource

    self.show_presenter = Hyrax::Vdc::ResourcePresenter

    def new
      super
      # TODO: Am I using a presenter correctly here...?
      user_profile_presenter = Hyrax::UserProfilePresenter.new(current_user, current_ability)
      @default_creator = user_profile_presenter.full_name
    end

    def create
      #byebug
      super
    end

    def edit
      super
      # TODO: Am I using a presenter correctly here...?
      user_profile_presenter = Hyrax::UserProfilePresenter.new(current_user, current_ability)
      @default_creator = user_profile_presenter.full_name
    end
  end
end
