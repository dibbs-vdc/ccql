namespace :notch8 do
  desc 'Setup default admin set and users'
  task :"setup" => :environment do |task, args|
    DefaultAdminSetService.run
  end
end