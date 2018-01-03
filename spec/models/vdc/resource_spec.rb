# Generated via
#  `rails generate hyrax:work Vdc::Resource`
require 'rails_helper'

RSpec.describe Vdc::Resource, "#new" do

  context "new Vdc::Resource" do

    it "has appropriate human_readable_type" do
      res = Vdc::Resource.new
      expect(res.human_readable_type).to eq "Resource"
    end

    it "has correct properties" do
      res = Vdc::Resource.new(title: ["Test Title"],
                              vdc_type: "Resource",
                              identifier_system: "123",
                              identifier_doi: "Test DOI",
                              vdc_creator: ["test_creator_id"],
                              authoritative_name: "Placeholder",
                              authoritative_name_uri: "PlaceholderURI",
                              vdc_title: "Test Title",
                              abstract: "Test Abstract",
                              funder: ["Test Funder 1", "Test Funder 2"],
                              research_problem: "Test Research Problem",
                              note: ["Test Note"],
                              readme_file: "Test README File",
                              readme_abstract: "Test Readme abstract",
                              creation_date: ["2017-12-05"],
                              extent: "0",
                              format: [],
                              discipline: ["Test Discipline"],
                              coverage_spatial: ["Test Spatial"],
                              coverage_temporal: ["Test Temporal"],
                              relation_uri: ["http://www.google.com"],
                              relation_type: ["Test Relation Type"],
                              vdc_license: "https://opendatacommons.org/licenses/by/1-0/",
                              creation_date: ["2018/01/01"])
    end
  end  
end
