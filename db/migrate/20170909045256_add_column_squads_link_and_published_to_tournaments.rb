class AddColumnSquadsLinkAndPublishedToTournaments < ActiveRecord::Migration[5.1]
  def change
    add_column :tournaments, :cricbuzz_tournament_url, :string
    add_column :tournaments, :published,  :boolean, default: false
  end
end
