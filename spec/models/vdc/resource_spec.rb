# Generated via
#  `rails generate hyrax:work Vdc::Resource`
require 'rails_helper'

RSpec.describe Vdc::Resource do
  it "is valid with a title" do
    resource = Vdc::Resource.new(title: ['test_resource'])

    expect( resource.valid? ).to eq(true)
    expect( resource.save ).to eq(true)
  end

  it "validates the presence of a title" do
    resource = Vdc::Resource.new

    expect( resource.save ).to eq(false)
    expect( resource.errors.messages).to include(:title => ["Your resource must have a title."])
  end
end
