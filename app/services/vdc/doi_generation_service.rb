# app/services/vdc/doi_generation_service.rb
class Vdc::DoiGenerationService
  def initialize(params)
    @work = params[:work]
  end

  # If a DOI already exists for the work, that DOI gets returned.
  # Otherwise, a doi is generated and returned.
  def generate_doi
    return @work.identifier_doi if doi_exists?

    # TODO: This is a fake generated for demo purposes.
    #       Eventually, this should be replaced with code using the EZID API.
    "http://dx.doi.org/doi:99.0000/#{@work.id}"
  end

  def doi_exists?
    !@work.identifier_doi.nil? and !@work.identifier_doi.empty?
  end
end

