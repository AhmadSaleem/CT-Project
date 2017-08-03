class RemoveColumnFromMatch < ActiveRecord::Migration[5.1]
  def change
    remove_column :matches, :first_opponent,  :string
    remove_column :matches, :second_opponent, :string
  end
end
