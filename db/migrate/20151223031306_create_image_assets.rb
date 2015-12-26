class CreateImageAssets < ActiveRecord::Migration
  def change
    create_table :image_assets do |t|
      t.string :asset
      t.integer :size
      t.string :filename
      t.string :content_type
      t.integer :operation_id

      t.timestamps
    end
  end
end
