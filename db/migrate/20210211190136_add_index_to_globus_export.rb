class AddIndexToGlobusExport < ActiveRecord::Migration[5.2]
  def change
    add_index :globus_exports, :dataset_id, unique: true
  end
end
