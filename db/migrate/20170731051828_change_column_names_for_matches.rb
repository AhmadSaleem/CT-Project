class ChangeColumnNamesForMatches < ActiveRecord::Migration[5.1]
  def up
    rename_column :matches, :opponent,   :first_opponent
    rename_column :matches, :opponent_1, :second_opponent
  end

  def down
    rename_column :matches, :first_opponent, :opponent
    rename_column :matches, :second_opponent, :opponent_1
  end
end
