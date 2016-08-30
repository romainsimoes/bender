class FixColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :products, :titre, :name
  end
end
