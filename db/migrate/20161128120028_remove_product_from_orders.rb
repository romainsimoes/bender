class RemoveProductFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :product, :string
  end
end
