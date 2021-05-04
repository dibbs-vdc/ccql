class FixGlobusFields < ActiveRecord::Migration[5.2]
  def change
    change_column :globus_exports, :expected_file_sets, :text
    change_column :globus_exports, :completed_file_sets, :text
  end
end
