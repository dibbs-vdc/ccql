# app/services/vdc_funding_sources_service.rb
module VdcFundingSourcesService
  mattr_accessor :authority
  self.authority = Qa::Authorities::Local.subauthority_for('vdc_funding_sources')

  # TODO: Not sure if there's a better way to do this, but I had to register my subauthority
  #       from the rails console with the following command:
  #
  # > Qa::Authorities::Local.register_subauthority('vdc_funding_sources', 'Qa::Authorities::Local::FileBasedAuthority')
  #
  # Do I add this to the hyrax.rb config??

  def self.reveal_funder_value(*args)
    args[0][0]
  end 

  def self.select_all_options
    authority.all.map do |element|
      [element[:label], element[:id]]
    end
  end

  def self.label(id)
    authority.find(id).fetch('term')
  end
end

