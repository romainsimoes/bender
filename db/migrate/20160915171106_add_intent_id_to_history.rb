class AddIntentIdToHistory < ActiveRecord::Migration[5.0]
  def change
    add_reference :histories, :intent, foreign_key: true
  end
end
