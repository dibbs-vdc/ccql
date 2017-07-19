# Generated via
#  `rails generate hyrax:work Vdc::Resource`
module Hyrax
  class Vdc::ResourceForm < Hyrax::Forms::WorkForm
    self.model_class = ::Vdc::Resource
    self.terms += [:resource_type]
  end
end
