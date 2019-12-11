# app/services/vdc/doi_generation_service.rb
module Vdc
  class DoiGenerationService
    DOI_URL               = ENV['DATACITE_URL']
    TYPE                  = 'dois'
    IDENTIFIER_TYPE       = 'DOI'
    PUBLISHER             = 'Virtual Data Collaboratory'
    RESOURCE_TYPE_GENERAL = 'Dataset'
    DESCRIPTION_TYPE      = 'Abstract'
    SCHEMA_VERSION        = 'http://datacite.org/schema/kernel-4'
    DATACITE_CORE_ATTRS   = [
      'abstract', 'creation_date', 'genre',
      'identifier_doi', 'vdc_creator', 'vdc_title'
    ].freeze

    class_attribute :logger
    self.logger = Sidekiq.logger

    def initialize(resource:, changes: nil)
      @resource      = resource
      @changes       = changes.present? ? JSON.parse(changes).with_indifferent_access : {}
      @changed_attrs = @changes.keys
    end

    def check_doi
      generate_doi! if generate_doi?
      update_doi! if update_doi?
    end

    def generate_doi!
      logger.info "Generating DOI for Resource ID=#{@resource.id}"
      response = register_datacite_doi(format_metadata)
      handle_registration_error(response) unless response.status == 201

      @resource.identifier_doi = JSON.parse(response.body).dig('data', 'attributes', 'doi')
      @resource.save!
      @resource.identifier_doi
    end

    def register_datacite_doi(metadata)
      doi_uri = URI.parse(URI.encode(DOI_URL.strip))

      conn = Faraday.new(headers: { 'Content-Type': 'application/vnd.api+json' })
      conn.basic_auth(ENV['DATACITE_LOGIN'], ENV['DATACITE_PASSWORD'])

      conn.post(doi_uri, metadata)
    end

    def update_doi!
      logger.info "Updating DOI for Resource ID=#{@resource.id}"
      response = update_datacite_doi(format_metadata)
      handle_registration_error(response) unless response.status == 200

      @resource.identifier_doi
    end

    def update_datacite_doi(metadata)
      doi_uri = URI.parse(URI.encode("#{DOI_URL}/#{@resource.identifier_doi}".strip))

      conn = Faraday.new(headers: { 'Content-Type': 'application/vnd.api+json' })
      conn.basic_auth(ENV['DATACITE_LOGIN'], ENV['DATACITE_PASSWORD'])

      conn.put(doi_uri, metadata)
    end

    ##
    # DataCite mandatory properties:
    # https://support.datacite.org/docs/schema-properties-overview-v43#section-table-1-datacite-mandatory-properties
    def format_metadata
      metadata = {
        'data': {
          'id': @resource.id,
          'type': TYPE,
          'attributes': {
            'event': 'publish',
            'doi': build_doi,
            'creators': [{
              'name': get_creator_name
            }],
            'titles': [{
              'title': @resource.vdc_title
            }],
            'publisher': PUBLISHER,
            'publicationYear': parse_creation_date_year,
            'types': {
              'resourceType': @resource.genre,
              'resourceTypeGeneral': RESOURCE_TYPE_GENERAL
            },
            'descriptions': [{
              'description': @resource.abstract,
              'descriptionType': DESCRIPTION_TYPE
            }],
            'url': get_work_url,
            'schemaVersion': SCHEMA_VERSION
          }
        }
      }.to_json
    end

    def generate_doi?
      @resource.identifier_doi.blank?
    end

    # If any of the core DataCite attributes have been changed,
    # update the DataCite doi.
    def update_doi?
      @changed_attrs.map { |attr| DATACITE_CORE_ATTRS.include?(attr) }.any?
    end

    def build_doi
      return @resource.identifier_doi if @resource.identifier_doi.present?
      "#{ENV['DATACITE_PREFIX']}/#{@resource.id}"
    end

    def get_creator_name
      p = Vdc::Person.find(@resource.vdc_creator.first)
      User.where(email: p.email).first&.display_name
    end

    def parse_creation_date_year
      @resource.creation_date&.first&.split('-')&.first
    end

    def get_work_url
      work_url =
        Rails.application.routes.url_helpers.send(
          "#{Hyrax::Name.new(Vdc::Resource).singular_route_key}_url",
          @resource.id,
          host: ENV['HYRAX_BASE_HOSTNAME']
        )

      work_url.sub('http', 'https')
    end

    def handle_registration_error(response)
      # 400 Bad Request (JSON::ParserError)
      # 401 Bad Credentials
      # 404 Not Found (most often occurred in reference to Client, check credentials)
      # 422 Unprocessable Entity (doi taken, unpermitted params)
      # 500 Internal Server Error (JSON::ParserError, unpermitted params, CanCan::AuthorizationNotPerformed: CanCan::AuthorizationNotPerformed)

      original_error_message = JSON.parse(response.body).dig('errors').first

      if response.status == 404
        error_message_with_context = "#{original_error_message} Hint: ensure your DataCite Client login and password are valid."
        raise DoiRegistrationError, error_message_with_context
      else
        raise DoiRegistrationError, original_error_message
      end
    end

    class DoiRegistrationError < StandardError; end
  end
end
