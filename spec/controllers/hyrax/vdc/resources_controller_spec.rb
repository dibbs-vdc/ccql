# Generated via
#  `rails generate hyrax:work Vdc::Resource`

# To run: rspec spec/controllers/hyrax/vdc/resources_controller_spec.rb --format doc

require 'rails_helper'

RSpec.describe Hyrax::Vdc::ResourcesController do
  fixtures :users

  before do
    @routes = Hyrax::Engine.routes
  end

  it "signs user.yml in and out" do
    user_1 = users(:test_user_1)
    expect(user_1.approved).to eq true
    sign_in user_1
    expect(controller.current_user).to eq(user_1)
    sign_out user_1
  end

  it "signs non-yml user in and out" do
    user = User.create!(email: "user@example.org", password: "very-secret", approved: true)
    
    sign_in user
    expect(controller.current_user).to eq(user)
    sign_out user
    expect(controller.current_user).to be_nil

    user.destroy! # TODO: Do I need to do this to keep my test user db from getting bloated?
  end
  
  it "can create Vdc::Resource" do
    user_1 = users(:test_user_1)
    expect(user_1.approved).to eq true
    sign_in user_1
    expect(controller.current_user).to eq(user_1)

    # create resource
    vdc_resource = FactoryBot.create(:vdc_resource)
    vdc_resource.save

    expect(controller.class).to eq(Hyrax::Vdc::ResourcesController)
    # TODO: Do something here that's actually in the controller?

    # clean up
    vdc_resource.destroy
    sign_out user_1
  end

end
