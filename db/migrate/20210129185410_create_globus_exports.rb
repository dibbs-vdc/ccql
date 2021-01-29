class CreateGlobusExports < ActiveRecord::Migration[5.2]
  def change
    create_table :globus_exports do |t|
      t.string :dataset_id, null: false
      t.string :workflow_state

      t.timestamps
    end
  end
end
