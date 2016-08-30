class AddGoogleEmailToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :google_email, :string
  end
end
