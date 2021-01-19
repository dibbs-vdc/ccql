module Vdc::VdcCreatorForSelect
  extend ActiveSupport::Concern

  # Used to generate select collection in app/views/records/edit_fields/_vdc_creator.html.erb
  # TODO: Remove if you're able to get this generated via QA
  def vdc_creator_for_select
    field_list = "id, preferred_name_tesim"
    select_result = Blacklight.default_index.connection.select(params: { q: "*:*", fq: "has_model_ssim:\"Vdc::Person\"", fl: field_list, rows: 100000 })

    select_collection = []
    select_result['response']['docs'].each do |doc|
      select_collection << [doc["preferred_name_tesim"].first, doc['id']]
    end
    select_collection
  end
end
