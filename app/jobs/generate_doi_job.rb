class GenerateDoiJob < ApplicationJob

  def perform(resource, changes)
    return if ENV['DO_NOT_GENERATE_DOIS']
    Vdc::DoiGenerationService.new(resource: resource, changes: changes).check_doi
  end
end
