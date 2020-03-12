class RemoveColumnAvatarFileSizeFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :avatar_file_size, :bigint
  end
end
