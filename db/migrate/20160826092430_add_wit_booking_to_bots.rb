class AddWitBookingToBots < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :wit_booking, :boolean, default: false
  end
end
