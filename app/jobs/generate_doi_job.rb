class GenerateDoiJob < ApplicationJob

  def perform(resource, changes)
    Vdc::DoiGenerationService.new(resource: resource, changes: changes).check_doi
  end
end
