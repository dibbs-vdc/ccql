class CreateVdcUsages < ActiveRecord::Migration[5.1]
  def change
    create_table :vdc_usages do |t|
      t.string :work_gid
      t.references :user
      t.string :purpose

      t.timestamps
    end
  end
end
