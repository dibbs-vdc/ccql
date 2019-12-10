class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController
  with_themed_layout '1_column'

  protect_from_forgery with: :exception

  before_action :set_raven_context

  rescue_from ActiveRecord::RecordNotFound, with: :redirect_record_not_found
  rescue_from Blacklight::Exceptions::RecordNotFound, with: :redirect_record_not_found

  def redirect_record_not_found
    flash[:alert] = 'This resource cannot be found in the repository.'
    redirect_back fallback_location: root_url
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
