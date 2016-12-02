class AddProductToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :product, :json
  end
end
