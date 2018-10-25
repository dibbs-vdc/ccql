class RemoveDefaultDisciplineFromUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:users, :email, nil)
  end
end
