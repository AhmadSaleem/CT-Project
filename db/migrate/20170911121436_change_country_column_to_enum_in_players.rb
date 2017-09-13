class ChangeCountryColumnToEnumInPlayers < ActiveRecord::Migration[5.1]
  def up
    change_column :players, :country, 'integer USING CAST(country AS integer)', null: true
  end

  def down
    change_column :players, :country, :string, null: false
  end
end
