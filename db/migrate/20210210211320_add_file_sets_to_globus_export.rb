class AddFileSetsToGlobusExport < ActiveRecord::Migration[5.2]
  def change
    add_column :globus_exports, :expected_file_sets, :string, array: true
    add_column :globus_exports, :completed_file_sets, :string, array: true
  end
end
