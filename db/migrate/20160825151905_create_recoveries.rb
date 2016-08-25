class CreateRecoveries < ActiveRecord::Migration[5.0]
  def change
    create_table :recoveries do |t|
      t.string :step

      t.timestamps
    end
  end
end
