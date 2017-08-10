# app/renderers/funder_attribute_renderer.rb
class FunderAttributeRenderer < Hyrax::Renderers::AttributeRenderer
#class FunderRenderer < Hyrax::Renderers::AttributeRenderer
  def label
    "Funder" # TODO: find a way to get label configured in catalog_controller.rb
  end

  def attribute_value_to_html(value)
    %(<span itemprop="funder">#{value}</span>)
  end
end
