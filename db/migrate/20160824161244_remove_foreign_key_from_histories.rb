class RemoveForeignKeyFromHistories < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :histories, column: :pattern_id
  end
end
