FactoryBot.define do
  factory :uploaded_file, class: Hyrax::UploadedFile do
    file { Rack::Test::UploadedFile.new("#{::Rails.root}/spec/fixtures/dummy.pdf") }
    user_id { 1 }
  end
end
