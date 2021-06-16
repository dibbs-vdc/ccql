require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ccql
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.admin_mailer = config_for(:admin_mailer)

    # set default language to english
    config.i18n.default_locale = :en

    # Overrides
    config.to_prepare do
      Hyrax::CollectionIndexer.prepend Hyrax::Vdc::CollectionIndexerOverride
      Hyrax::CollectionsController.prepend Hyrax::Vdc::CollectionsControllerOverride
      Hyrax::Dashboard::CollectionsController.prepend Hyrax::Vdc::CollectionsControllerOverride
      Hyrax::My::CollectionsController.prepend Hyrax::My::Vdc::CollectionsControllerOverride
      Hyrax::UsersController.prepend Hyrax::Vdc::UsersControllerOverride
      Hyrax::Statistics::SystemStats.prepend Hyrax::Statistics::Vdc::SystemStatsOverride
      Hyrax::Admin::DashboardPresenter.prepend Hyrax::Admin::Vdc::DashboardPresenterOverride
      Hyrax::Actors::CreateWithFilesActor.prepend Hyrax::Actors::Vdc::CreateWithFilesActorOverride
      BrowseEverything::Driver.prepend BrowseEverythingOverride
    end
  end
end
