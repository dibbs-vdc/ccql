class DefaultAdminSetService

  def self.run
    if AdminSet.where(id: "admin_set/default").count == 0
      AdminSet.find_or_create_default_admin_set_id
    end
    users = ['archivist@example.com', 'admin@example.com', 'approved@example.com', 'rob@notch8.com']

    users.each do |email|
      User.where(email: email).first_or_create do |user|
        user.password = 'testing123'
        user.approved = true
      end
    end
  end

end