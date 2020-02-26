class CreateImgur < ActiveRecord::Migration[5.2]
  def change
    create_table :imgurs do |t|
      t.integer :instagram_id
      t.string :type
      t.string :file
      t.datetime :deleted_at

      t.timestamps null: false
    end

    add_index :imgurs, [:type, :instagram_id]
  end
end
