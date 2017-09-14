class AddColumnApprovedToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :approved, :boolean, default: false
  end
end
