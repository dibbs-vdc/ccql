require 'rails_helper'

RSpec.describe Vdc::Person do
  subject(:person) { FactoryBot.build(:person) }

  describe '#to_solr' do
    it 'has a name' do
      expect(person.to_solr)
        .to include('preferred_name_tesim' => [person.preferred_name])
    end
  end
end
