class AddShopNameToBots < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :shop_name, :string
  end
end
