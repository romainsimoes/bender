class CreatePatterns < ActiveRecord::Migration[5.0]
  def change
    create_table :patterns do |t|
      t.string :trigger
      t.string :answer

      t.timestamps
    end
  end
end
