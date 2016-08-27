class AddStreetToBots < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :street, :string
  end
end
