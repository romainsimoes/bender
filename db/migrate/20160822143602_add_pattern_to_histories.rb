class AddPatternToHistories < ActiveRecord::Migration[5.0]
  def change
    add_reference :histories, :pattern, foreign_key: true
  end
end
