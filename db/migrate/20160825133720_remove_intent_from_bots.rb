class RemoveIntentFromBots < ActiveRecord::Migration[5.0]
  def change
    remove_column :bots, :intent, :string
  end
end
