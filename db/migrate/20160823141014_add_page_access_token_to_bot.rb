class AddPageAccessTokenToBot < ActiveRecord::Migration[5.0]
  def change
    add_column :bots, :page_access_token, :string
  end
end
