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

  # Easy handling of strong parameters for custom registration attributes:
  # https://github.com/plataformatec/devise#strong-parameters
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Easy handling of strong parameters for custom registration attributes:
  # https://github.com/plataformatec/devise#strong-parameters
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:vdc_referral_method,:vdc_referral_method_other,:first_name, :last_name, :organization, :organization_other, :vdc_role, :vdc_role_other, :discipline, :discipline_other, :edu_person_principal_name, :cv_link, :collaboration_open_science_framework,:collaboration_linkedin,:collaboration_vivo,:collaboration_institutional_repo,:collaboration_institutional_repo_name,:collaboration_other,:usage_deposit_files,:usage_use_files,:usage_use_tools_on_vdc_data,:usage_use_tools_on_external_data,:usage_description,:usage_duration])

  end
end
