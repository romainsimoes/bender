class AddCityToBots < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :city, :string
  end
end
