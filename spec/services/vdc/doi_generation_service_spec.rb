require 'rails_helper'

RSpec.describe Vdc::DoiGenerationService do
  subject(:service)   { described_class.new(resource: resource) }
  let(:resource)      { FactoryBot.create(:vdc_resource, :ready_for_doi) }
  let(:changes)       { { 'vdc_title': ['before', 'after'], 'abstract': ['press', 'x'] }.to_json }
  let(:response_body) {
    {
      'data': {
        'id': resource.id,
        'type': described_class::TYPE,
        'attributes': {
          'event': 'publish',
          'doi': "10.33586/#{resource.id}",
          'creators': [{
            'name': 'Doe, John'
          }],
          'titles': [{
            'title': resource.vdc_title
          }],
          'publisher': described_class::PUBLISHER,
          'publicationYear': Hyrax::TimeService.time_in_utc.strftime('%Y'),
          'types': {
            'resourceType': resource.genre,
            'resourceTypeGeneral': described_class::RESOURCE_TYPE_GENERAL
          },
          'descriptions': [{
            'description': resource.abstract,
            'descriptionType': described_class::DESCRIPTION_TYPE
          }],
          'url': "https://#{ENV['HYRAX_BASE_HOSTNAME']}/concern/vdc/resources/#{resource.id}",
          'schemaVersion': described_class::SCHEMA_VERSION
        }
      }
    }.to_json
  }

  describe '#initialize' do
    it 'raises an error if not provided a resource' do
      expect { Vdc::DoiGenerationService.new }
        .to raise_error(ArgumentError)
    end

    context 'if no changes are present' do
      it 'does not throw error' do
        expect { Vdc::DoiGenerationService.new(resource: resource, changes: nil) }
          .to_not raise_error
      end
    end

    context 'if changes are present' do
      it 'does not throw error' do
        expect { Vdc::DoiGenerationService.new(resource: resource, changes: changes) }
          .to_not raise_error
      end
    end
  end

  describe '#check_doi' do
    context 'when Resource#identifier_doi is blank' do
      it 'will call #generate_doi!' do
        expect(service).to receive(:generate_doi!)
        service.check_doi
      end

      it 'will not call #update_doi!' do
        expect(service).to receive(:generate_doi!)
        expect(service).to_not receive(:update_doi!)
        service.check_doi
      end
    end

    context 'when a core DataCite metadata attribute has been updated' do
      before do
        resource.identifier_doi = 'hello world'
        resource.save!
        service.instance_variable_set(
          :@changed_attrs,
          [described_class::DATACITE_CORE_ATTRS.sample]
        )
      end

      it 'will call #update_doi!' do
        expect(service).to receive(:update_doi!)
        service.check_doi
      end

      it 'will not call #generate_doi!' do
        expect(service).to receive(:update_doi!)
        expect(service).to_not receive(:generate_doi!)
        service.check_doi
      end
    end

    context 'when Resource#identifier_doi is present and no DataCite metadata has changed' do
      before do
        resource.identifier_doi = 'hello world'
        resource.save!
      end

      it 'will call neither #generate_doi! nor #update_doi!' do
        expect(service).to_not receive(:generate_doi!)
        expect(service).to_not receive(:update_doi!)
        service.check_doi
      end
    end
  end

  describe '#generate_doi!' do
    context 'when a Resource is missing a doi' do
      before do
        doi_uri = URI.parse(URI.encode('https://api.test.datacite.org/dois'.strip))
        stub_request(:post, doi_uri)
          .to_return(
            status: 201,
            body: {
              'data': {
                'attributes': {
                  'doi': "10.33586/#{resource.id}"
                }
              }
            }.to_json
          )
      end

      it 'generates and assigns a doi' do
        expect(resource.identifier_doi).to eq(nil)

        expect(service.generate_doi!).to eq("10.33586/#{resource.id}")
        expect(resource.identifier_doi).to eq("10.33586/#{resource.id}")
      end
    end

    # #handle_registration_error tests
    context 'when the DataCite API returns a 404' do
      before do
        doi_uri = URI.parse(URI.encode('https://api.test.datacite.org/dois'.strip))
        stub_request(:post, doi_uri)
          .to_return(
            status: 404,
            body: {
              'errors': [{
                'status': '404',
                'title': "The resource you are looking for doesn't exist."
              }]
            }.to_json
        )
      end

      it 'formats the error message and provides a tip' do
        expect { service.generate_doi! }
          .to raise_error(described_class::DoiRegistrationError, /Hint:/)
      end
    end

    context 'when the DataCite API returns an error other than a 404' do
      before do
        doi_uri = URI.parse(URI.encode('https://api.test.datacite.org/dois'.strip))
        stub_request(:post, doi_uri)
          .to_return(
            status: 422,
            body: {
              'errors': [{
                'status': '422',
                'title': 'found unpermitted parameter: :bad_param'
              }]
            }.to_json
        )
      end

      it 'formats the error message and provides a tip' do
        expect { service.generate_doi! }
          .to raise_error(described_class::DoiRegistrationError, /found unpermitted parameter/)
      end
    end
  end

  describe '#update_doi!' do
    before do
      resource.vdc_title = 'red'
      resource.identifier_doi = "10.33586/#{resource.id}"
      resource.save!
    end

    it 'updates an existing DataCite doi' do
      resource.vdc_title = 'blue'
      resource.save!
      service.instance_variable_set(:@changed_attrs, ['vdc_title'])
      expect(service.update_doi?).to eq(true)

      doi_uri = URI.parse(URI.encode("https://api.test.datacite.org/dois/#{resource.identifier_doi}".strip))
      stub_request(:put, doi_uri)
        .to_return(
          status: 200,
          body: {
            'data': {
              'attributes': {
                'doi': "10.33586/#{resource.id}",
                'titles': [{
                  'title': 'blue'
                }]
              }
            }
          }.to_json
      )

      expect { service.update_doi! }.to_not raise_error(described_class::DoiRegistrationError)
      expect(service.update_doi!).to eq(resource.identifier_doi)
    end
  end

  describe '#format_metadata' do
    it 'builds a JSON block with the relevant resource data' do
      expect(service.format_metadata).to eq(response_body)
    end
  end

  describe '#generate_doi?' do
    context 'if #identifier_doi is blank' do
      it 'returns true' do
        expect(service.generate_doi?)
          .to eq(true)
      end
    end

    context 'if #identifier_doi is present' do
      before do
        resource.identifier_doi = 'hello world'
        resource.save!
      end

      it 'returns false' do
        expect(service.generate_doi?)
          .to eq(false)
      end
    end
  end

  describe '#update_doi?' do
    context 'if none of the core DataCite metadata attributes have changed' do
      it 'returns false' do
        expect(service.update_doi?)
          .to eq(false)
      end
    end

    context 'if one of the core DataCite metadata attributes has changed' do
      it 'returns true' do
        service.instance_variable_set(
          :@changed_attrs,
          [described_class::DATACITE_CORE_ATTRS.sample]
        )

        expect(service.update_doi?)
          .to eq(true)
      end
    end
  end

  describe '#build_doi' do
    it 'constructs a string in doi format' do
      expect(service.build_doi)
        .to eq("#{ENV['DATACITE_PREFIX']}/#{resource.id}")
    end
  end

  describe '#get_creator_name' do
    it 'gets the full, formatted name of the depositor' do
      user = User.where(email: resource.depositor).first

      expect(service.get_creator_name)
        .to eq(user.display_name)
    end
  end

  describe '#parse_creation_date_year' do
    it 'returns the year from :creation_date' do
      expect(service.parse_creation_date_year)
        .to eq(Hyrax::TimeService.time_in_utc.strftime('%Y'))
    end
  end

  describe '#get_work_url' do
    it 'returns the full path to the Resource' do
      expect(service.get_work_url)
        .to eq("https://#{ENV['HYRAX_BASE_HOSTNAME']}/concern/vdc/resources/#{resource.id}")
    end
  end
end
