class CreateDicoms < ActiveRecord::Migration
  def change
    create_table :dicoms do |t|
      t.integer :user_id
      t.string :pc_url
      t.string :mobile
      t.string :instance_create

      t.timestamps
    end
  end
end
