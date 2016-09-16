class CreateIntents < ActiveRecord::Migration[5.0]
  def change
    create_table :intents do |t|
      t.string :name
      t.string :answer
      t.references :bot, foreign_key: true
    end
  end
end
