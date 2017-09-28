# TODO: This is very much a work in progress... It's not working now, but the skeleton is there. copied over from one of the existing services.... if you want a working example, look at those first.

# app/services/vdc/creator_options_service.rb
class CreatorOptionsService
  def self.select_all_options
      users = ::User.all
      # Should return array of hashes with ids, labels, and values(optional)                                                                                                           
      user_list = []
      users.each do |u|
        preferred_name = "#{u.last_name}, #{u.first_name}"
        if u.approved and (u.identifier_system != nil)
          user_list << [preferred_name, u.identifier_system]
        end
      end
      user_list    
    end
  end

  def self.label(id)
    u = ::User.find(id)
    preferred_name = "#{u.last_name}, #{u.first_name}"
  end
end

