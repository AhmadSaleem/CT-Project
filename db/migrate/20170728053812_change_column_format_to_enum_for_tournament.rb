class ChangeColumnFormatToEnumForTournament < ActiveRecord::Migration[5.1]
  def up
    change_column :tournaments, :format, 'integer USING CAST(format AS integer)'
  end

  def down
    change_column :tournaments, :format, :string
  end
end
