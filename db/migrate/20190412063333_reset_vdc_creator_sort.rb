class ResetVdcCreatorSort < ActiveRecord::Migration[5.1]
  def change
    Vdc::Resource.find_each do |v|
      v.vdc_creator = v.vdc_creator
      v.save
      print '.'
    end
  end
end
