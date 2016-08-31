class AddBotReferenceToRecoveries < ActiveRecord::Migration[5.0]
  def change
    add_reference :recoveries, :bot, foreign_key: true
  end
end
