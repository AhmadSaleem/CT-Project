class CricBuzzMatchUrlToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :cricbuzz_match_url, :string
  end
end
