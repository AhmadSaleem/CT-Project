class AddColumnAvailableCoinsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :available_coins, :integer, null: false, default: 1000
  end
end
