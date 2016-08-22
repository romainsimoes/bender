class CreateBots < ActiveRecord::Migration[5.0]
  def change
    create_table :bots do |t|
      t.string :name
      t.string :token
      t.boolean :enable

      t.timestamps
    end
  end
end
