class AddStripeCardTokenToCrawler < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :card_token, :string
  end
end
