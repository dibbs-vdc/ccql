# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminSet.find_or_create_default_admin_set_id

if Rails.env.development?
  users = ['archivist@example.com', 'admin@example.com', 'approved@example.com']

  users.each do |email|
    User.where(email: email).first_or_create do |user|
      user.password = 'testing123'
      user.approved = true
    end
  end

  class WorkFactory
    def actor_create(attributes:, work_class: Vdc::Resource)
      user    = User.find_by(email: 'admin@example.com')
      ability = Ability.new(user)
      work    = work_class.new
      env     = Hyrax::Actors::Environment.new(work, ability, attributes)

      Hyrax::CurationConcern.actor.create(env)
    end
  end

  factory = WorkFactory.new
  factory.actor_create(attributes: { title: ['Test'] })
end
