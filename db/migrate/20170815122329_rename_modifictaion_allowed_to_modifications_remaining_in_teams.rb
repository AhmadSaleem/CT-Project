class RenameModifictaionAllowedToModificationsRemainingInTeams < ActiveRecord::Migration[5.1]
  def change
    rename_column :teams, :modifications_allowed, :modifications_remaining
  end
end
