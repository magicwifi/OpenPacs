class AddOperationIdToDicom < ActiveRecord::Migration
  def change
    add_column :dicoms, :operation_id, :integer
  end
end
