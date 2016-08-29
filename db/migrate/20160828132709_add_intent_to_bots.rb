class AddIntentToBots < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :intent, :string, array: true, default: []
  end
end
