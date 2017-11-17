# app/services/vdc_genres_service.rb
module VdcGenresService
  mattr_accessor :authority
  #self.authority = Qa::Authorities::Local.subauthority_for('genres')            # NO GOOD
  self.authority = Qa::Authorities::Local.subauthority_for('vdc_genres')

  # NOTE: Not sure if there's a better way to do this, but I had to register my subauthority vdc_genres
  #       from the rails console with the following command:
  #
  # > Qa::Authorities::Local.register_subauthority('vdc_genres', 'Qa::Authorities::Local::FileBasedAuthority')
  #
  # Also, I think there's a table-based 'genre' subauthority in the main hyrax gem that I wasn't initially
  # aware of.  I originally created a config/authorities/genres.yml file, only to not have the 
  # service function properly. When I renamed it to be vdc_genres, it seemed to work.

  def self.select_all_options
    authority.all.map do |element|
      [element[:label], element[:id]]
    end
  end

  def self.label(id)
    authority.find(id).fetch('term')
  end
end

