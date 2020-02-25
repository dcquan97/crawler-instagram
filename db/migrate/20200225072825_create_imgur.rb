class CreateImgur < ActiveRecord::Migration[5.2]
  def change
    create_table :imgurs do |t|
      t.string :type
      t.string :file
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
