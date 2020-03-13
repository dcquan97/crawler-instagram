class CreateImgur < ActiveRecord::Migration[5.2]
  def change
    create_table :imgurs do |t|
      t.string :type
      t.string :file
      t.string :thumbnail
      t.datetime :deleted_at
      t.references :instagram, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :imgurs, [:type, :instagram_id]
  end
end
