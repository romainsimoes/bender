class RemoveWitColumnsFromBots < ActiveRecord::Migration[5.0]
  def change
    remove_column :bots, :wit_booking, :boolean
    remove_column :bots, :wit_opening_times, :boolean
    remove_column :bots, :wit_welcome, :boolean
  end
end
