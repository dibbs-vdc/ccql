# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'hyrax/base/_form_metadata.html.erb', type: :view do
  let(:ability) { :fake_ability }

  let(:form_template) do
    %(
      <%= simple_form_for @form, url: 'http://example.com' do |f| %>
        <%= render "hyrax/base/form_metadata", f: f %>
      <% end %>
     )
  end

  let(:page) do
    assign(:form, form)
    render inline: form_template
    Capybara::Node::Simple.new(rendered)
  end

  context 'with a CollectionForm' do
    let(:coll) { FactoryBot.build(:collection) }
    let(:form) { Hyrax::Vdc::CollectionForm.new(coll, ability, controller) }

    it 'has collection_size' do
      expect(page).to have_form_field(:collection_size)
        .as_single_valued.on_model(coll.class)
        .with_label('Project Size')
        .and_options('1_gb') # check vocab is loading with one value
    end
  end
end
