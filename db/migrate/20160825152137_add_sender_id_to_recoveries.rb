class AddSenderIdToRecoveries < ActiveRecord::Migration[5.0]
  def change
    add_column :recoveries, :sender_id, :string
  end
end
