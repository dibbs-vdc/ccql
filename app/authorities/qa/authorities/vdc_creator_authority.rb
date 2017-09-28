# TODO: Initially, I thought to put this in 
# app/authorities/qa/authorities/vdc/creator_authority.rb
# but I couldn't get it to work... why not?

# Example query: http://localhost:3000/authorities/search/vdc_creator_authority/find?q=part_of_preferred_name

# TODO: Is it okay that I expose these ids? Probably not... How do I not expose these? User auth?
module Qa::Authorities
  class VdcCreatorAuthority < Qa::Authorities::Base
    # Arguments can be (query) or (query, terms_controller)
    def search(_q)
      users = ::User.all
      # Should return array of hashes with ids, labels, and values(optional)
      user_list = []
      users.each do |u|
        preferred_name = "#{u.last_name}, #{u.first_name}"
        #TODO: Find a better to determine matches. This was just thrown together to get the service to work.
        #      It doesn't yet account for #{u.first_name u.last_name}.
        #      Eventually, there's probably a more efficient way.
        matches = preferred_name.scan(/#{_q}/i)
        if u.approved and (u.identifier_system != nil) and matches.count > 0
          user_list << { label: preferred_name, id: u.identifier_system, value: u.identifier_system}
        end
      end
      user_list
    end
  end
end
