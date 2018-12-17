require 'rails_helper'

RSpec.describe Vdc::CatalogSearchBuilder do
  subject(:builder) { described_class.new(controller) }
  let(:controller)  { :fake_controller }

  describe '#models' do
    it 'includes the Vdc::Person model' do
      expect(builder.models).to include Vdc::Person
    end
  end
end
