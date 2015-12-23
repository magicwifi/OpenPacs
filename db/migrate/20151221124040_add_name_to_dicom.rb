class AddNameToDicom < ActiveRecord::Migration
  def change
    add_column :dicoms, :name, :string
  end
end
