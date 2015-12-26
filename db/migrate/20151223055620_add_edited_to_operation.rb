class AddEditedToOperation < ActiveRecord::Migration
  def change
    add_column :operations, :edited, :boolean
  end
end
