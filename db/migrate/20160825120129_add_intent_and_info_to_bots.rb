class AddIntentAndInfoToBots < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :intent, :string
    add_column :bots, :info, :json
  end
end
