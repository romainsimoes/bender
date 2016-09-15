class DeleteGoogleUidAndGoogleEmailFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :google_email, :string
    remove_column :users, :google_uid, :string
  end
end
