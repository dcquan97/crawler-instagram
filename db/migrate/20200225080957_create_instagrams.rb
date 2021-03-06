class CreateInstagrams < ActiveRecord::Migration[5.2]
  def change
    create_table :instagrams do |t|
      t.string :content
      t.string :post_id
      t.integer :like_counter
      t.datetime :deleted_at
      t.datetime :time_post
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
