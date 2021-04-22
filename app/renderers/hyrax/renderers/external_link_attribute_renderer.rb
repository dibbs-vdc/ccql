# OVERRIDE: Hyrax 2.9 make external links open new tab or window
module Hyrax
  module Renderers
    class ExternalLinkAttributeRenderer < AttributeRenderer
      private

      def li_value(value)
        auto_link(value, html: { target: '_blank' }) do |link|
          "<span class='glyphicon glyphicon-new-window'></span>&nbsp;#{link}"
        end
      end
    end
  end
end
