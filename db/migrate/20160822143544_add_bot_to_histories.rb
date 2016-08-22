class AddBotToHistories < ActiveRecord::Migration[5.0]
  def change
    add_reference :histories, :bot, foreign_key: true
  end
end
