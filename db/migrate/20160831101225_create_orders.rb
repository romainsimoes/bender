class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :product
      t.string :address
      t.string :status
      t.references :bot, foreign_key: true

      t.timestamps
    end
  end
end
