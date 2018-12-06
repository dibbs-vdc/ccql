# Generated via
#  `rails generate hyrax:work Vdc::Resource`
require 'rails_helper'

RSpec.describe Hyrax::Vdc::ResourcesController do
  describe '#create' do 
    it 'sets creation date to now'
  end

  describe '#update' do 
    it 'does not change creation date'
    context 'when moving to Public' do 
      it 'updates creation date to now'
    end 
    context 'when moving to VDC' do 
      it 'updates creation date to now'
    end 
  end
end
