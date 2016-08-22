class AddUserToBots < ActiveRecord::Migration[5.0]
  def change
    add_reference :bots, :user, foreign_key: true
  end
end
