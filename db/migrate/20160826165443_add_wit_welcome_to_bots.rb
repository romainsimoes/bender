class AddWitWelcomeToBots < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :wit_welcome, :boolean, default: false
  end
end
