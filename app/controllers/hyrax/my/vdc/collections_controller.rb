#TODO: Move this to hyrax/my/vdc/collections_controller?
module Hyrax
  module My
    class Vdc::CollectionsController < CollectionsController
      def index
        super
        @selected_tab = 'projects'
      end
    end
  end
end
