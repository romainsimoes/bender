class AddSenderIdToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :sender_id, :string
  end
end
