class AddDefaultValueToEnableFromBots < ActiveRecord::Migration[5.0]
  def change
    change_column :bots, :enable, :boolean, default: false
  end
end
