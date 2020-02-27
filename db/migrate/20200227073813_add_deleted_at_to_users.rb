class AddDeletedAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :instagrams, :deleted_at
    add_index :imgurs, :deleted_at
    add_index :users, :deleted_at
  end
end
