class VdcTypeAttributeRenderer < Hyrax::Renderers::FacetedAttributeRenderer
  def label
    "Type (VDC)"
  end

  def attribute_value_to_html(value)
    %(<span itemprop="vdc_type">#{value}</span>)
  end
end
