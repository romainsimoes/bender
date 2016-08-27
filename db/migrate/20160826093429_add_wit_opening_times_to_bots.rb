class AddWitOpeningTimesToBots < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :wit_opening_times, :boolean, default: false
  end
end
