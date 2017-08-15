class CreatePointsSummaries < ActiveRecord::Migration[5.1]
  def change
    create_table :points_summaries do |t|
      t.integer :format
      t.integer :scoring_area
      t.integer :points
      t.timestamps
    end
  end
end
