class UpdateColumnsToAllowNullValuesInPlayers < ActiveRecord::Migration[5.1]
  def up
    change_column :players, :batting_style, :string, null: true
    change_column :players, :bowling_style, :string, null: true
    change_column :players, :role, :integer, null: true
  end

  def down
    change_column :players, :batting_style, :string, null: false
    change_column :players, :bowling_style, :string, null: false
    change_column :players, :role, :integer, null: false
  end
end
