class RemoveOperationColumns < ActiveRecord::Migration
  def change
	remove_column :operations, :asset
	remove_column :operations, :poster
	remove_column :operations, :size
	remove_column :operations, :filename
	remove_column :operations, :content_type
  end
end
