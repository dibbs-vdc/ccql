require 'rails_helper'

RSpec.describe Collection, '#new' do
  context "new Collection" do
    it "has correct properties" do
      col = Collection.new(title: ["Test Title"],
                           vdc_type: "Collection",
                           identifier_system: "123",
                           vdc_title: "Test Title",
                           vdc_creator: ["test_creator_id"],
                           funder: ["Test Funder"],
                           collection_size: "50 MB",
                           note: "Test Note",
                           creation_date: ["2018-01-03"])
    end
  end
end
