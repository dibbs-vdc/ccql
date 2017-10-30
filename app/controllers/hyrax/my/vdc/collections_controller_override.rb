# Attempting to override from Hyrax Gem 1.0.4:
#  app/controllers/hyrax/my/collections_controller.rb
# See config/application.rb for prepend statement

module Hyrax
  module My
    module Vdc
      module CollectionsControllerOverride
        def index
          super
          @selected_tab = 'projects'
        end
      end
    end
  end
end
