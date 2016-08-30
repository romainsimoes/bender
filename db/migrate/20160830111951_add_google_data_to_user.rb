class AddGoogleDataToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :google_uid, :string
    add_column :users, :google_token, :string
  end
end
