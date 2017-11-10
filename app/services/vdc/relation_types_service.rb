# app/services/vdc_funding_sources_service.rb
module Vdc::RelationTypesService
  mattr_accessor :authority
  self.authority = Qa::Authorities::Local.subauthority_for('vdc_resource_relation_types')

  def self.select_all_options
    authority.all.map do |element|
      [element[:label], element[:id]]
    end
  end

  def self.label(id)
    authority.find(id).fetch('term')
  end
end

