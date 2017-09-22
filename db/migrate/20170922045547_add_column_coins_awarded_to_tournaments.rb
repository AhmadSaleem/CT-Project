class AddColumnCoinsAwardedToTournaments < ActiveRecord::Migration[5.1]
  def change
    add_column :tournaments, :coins_awarded, :boolean, default: false
  end
end
