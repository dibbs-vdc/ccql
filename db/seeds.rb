# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminSet.find_or_create_default_admin_set_id

if Rails.env.development?
  users = ['archivist@example.com', 'admin@example.com', 'approved@example.com', 'rob@notch8.com']

  users.each do |email|
    User.where(email: email).first_or_create do |user|
      user.password = 'testing123'
      user.approved = true
    end
  end

  class WorkFactory
    def actor_create(attributes:, work_class: Vdc::Resource)
      user    = FactoryBot.create(:user)
      ability = Ability.new(user)
      work    = work_class.new
      env     = Hyrax::Actors::Environment.new(work, ability, attributes)

      Hyrax::CurationConcern.actor.create(env)
    end
  end

  factory        = WorkFactory.new
  dummy_uri      = URI('file:///')
  dummy_uri.path = Rails.root.join('spec', 'fixtures', 'dummy.pdf').to_s
  attributes     = { title:        ['Test'],
                     remote_files: [{ url: dummy_uri.to_s }],
                     visibility:   'open' }

  factory.actor_create(attributes: attributes)
end

collection_types = Hyrax::CollectionType.all
collection_types.each do |c|
  next unless c.title =~ /^translation missing/
  oldtitle = c.title
  c.title = I18n.t(c.title.gsub("translation missing: en.", ''))
  c.save
  puts "#{oldtitle} changed to #{c.title}"
end
