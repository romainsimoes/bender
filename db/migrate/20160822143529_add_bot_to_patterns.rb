class AddBotToPatterns < ActiveRecord::Migration[5.0]
  def change
    add_reference :patterns, :bot, foreign_key: true
  end
end
